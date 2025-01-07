//
//  OrderView.swift
//  shd
//
//  Created by Тигран Дарчинян on 03.01.2025.
//

import SwiftUI
import Foundation
import iPhoneNumberField

struct OrderView: View {
    @StateObject private var viewModel: OrderViewModel
    
    @State private var isKeyboardActive = false
    @State private var showWebView = false
    
    @Environment(\.dismiss) var dismiss
    
    init(deliveryData: DeliveryData, contactsData: ContactsData, cartData: CartData) {
        _viewModel = StateObject(wrappedValue: OrderViewModel(
            deliveryData: deliveryData,
            contactsData: contactsData,
            cartData: cartData
        ))
    }
    
    var body: some View {
        VStack {
            OrderTypeSwitcher(orderIndex: $viewModel.orderIndex)
            
            ZStack {
                Form {
                    Section(header: Text("Список товаров")) {
                        let items = viewModel.cartData.items
                        
                        ForEach(items, id: \.id) { item in
                            let grams = item.gram ?? 0
                            let gramsText = (grams == 0)
                                ? "\(item.quantity)"
                                : "\(grams * item.quantity)"
                            
                            let totalPrice = item.price * item.quantity
                            
                            HStack {
                                Text(item.name)
                                    .font(.caption2).bold()
                                
                                Spacer()
                                
                                Text(gramsText)
                                    .font(.caption2)
                                
                                Spacer()
                                
                                Text("\(totalPrice) ₽")
                                    .font(.caption2)
                            }
                        }
                    }
                    
                    Section(header: Text("Дата и время")) {
                        DatePickerView(
                            currentTime: $viewModel.currentTime,
                            orderIndex: $viewModel.orderIndex,
                            deliveryData: viewModel.deliveryData,
                            contactsData: viewModel.contactsData
                        )
                        .padding(.vertical, 4)
                    }
                    if viewModel.orderIndex == 0 {
                    Section(header: Text("Адрес")) {
                        TextField("Введите адрес", text: $viewModel.address)
                            .padding(.vertical, 5)
                            .background(Color.clear)
                            .border(Color.clear, width: 0)
                        }
                        
                    } else {
                        if let c = viewModel.contactsData.contact {
                            Text("\(c.address)")
                        } else {
                            Text("ул, Парковая, 2")
                        }
                        
                    }
                    
                    Section(header: Text("Номер телефона")) {
                        iPhoneNumberField(text: $viewModel.phoneNumber)
                            .flagHidden(false)
                            .prefixHidden(false)
                            .maximumDigits(10)
                            .clearButtonMode(.whileEditing)
                            .onClear { _ in viewModel.phoneNumber = "" }
                        .padding(.vertical, 5)
                        .background(Color.clear)
                        .border(Color.clear, width: 0)
                    }
                    
                    Section(header: Text("Комментарий")) {
                        TextEditor(text: $viewModel.comment)
                            .padding(.vertical, 5)
                            .frame(height: 50)
                            .cornerRadius(8)
                            .background(Color.clear)
                            .border(Color.clear, width: 0)
                    }
                    
                    if viewModel.orderIndex == 0 {
                        Section(header: Text("Способ оплаты")) {
                            Picker("Оплата", selection: $viewModel.paymentMethod) {
                                ForEach(PaymentMethod.allCases) { method in
                                    Text(method.rawValue).tag(method)
                                }
                            }
                            .pickerStyle(.menu) // или .menu .inline, .wheel, .segmented
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
            }
            if !isKeyboardActive {
                VStack {
                    Button(action: {
                        viewModel.sendOrder()
                    }) {
                        if viewModel.isLoading {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                Spacer()
                                Text("Отправка...")
                                    .font(.callout).bold()
                                Spacer()
                            }
                            .font(.callout).bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("LightSlateGray"))
                            )
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        } else {
                            HStack(alignment: .center) {
                                if viewModel.orderIndex == 0 && viewModel.cartData.totalPrice < viewModel.deliveryData.delivery?.minDeliveryAmount ?? 0 {
                                    Text("Минимальная сумма заказа \(viewModel.deliveryData.delivery?.minDeliveryAmount ?? 0) ₽")
                                        .font(.caption)
                                } else {
                                    Text("Заказать:")
                                    Spacer()
                                    Text("\(viewModel.cartData.totalPrice) ₽")
                                }
                            }
                            .font(.callout).bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(viewModel.canSendOrder ? Color.main : Color("LightSlateGray"))
                            )
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                    }
                    .disabled(!viewModel.canSendOrder || viewModel.isLoading)
                    .padding(.horizontal, 16)
                
               
                    PrivacyPolicyView(showWebView: $showWebView, baseURL: viewModel.baseURL)
                        .padding(.bottom, 0)
                }
                .background(.clear)
            }
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("DarkModeBg"))
        .environment(\.locale, Locale(identifier: "ru"))
        .task {
            await viewModel.contactsData.fetchContacts()
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.isKeyboardActive = true
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { _ in
                self.isKeyboardActive = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.removeObserver(self,
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
        .onReceive(viewModel.$orderSent) { sent in
                    if sent {
                        dismiss()
                    }
                }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

