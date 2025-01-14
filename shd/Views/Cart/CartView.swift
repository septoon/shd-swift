//
//  CartView.swift
//  shd
//
//  Created by Тигран Дарчинян on 28.12.2024.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartData: CartData
    @ObservedObject var deliveryData: DeliveryData
    @ObservedObject var contactsData: ContactsData
    
    @State var showBottomSheet = false
    @State private var showClearCartAlert = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                    if cartData.items.isEmpty {
                        VStack {
                            Image("empty-cart")
                            Text("Вероятно, вы еще ничего не заказали.")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.body)
                                .padding(.top, 20)
                            Text("Перейдите в меню для заказа.")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        VStack {
                            List {
                                Section(header: Text("Ваш заказ")) {
                                    ForEach(cartData.items, id: \.id) { item in
                                        CartItemRow(item: item, cartData: cartData)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                Button(role: .destructive) {
                                                    cartData.deleteAllItems(item)
                                                } label: {
                                                    Text("Удалить")
                                                }
                                            }
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                        .padding(.bottom, 50)
                        .background(Color("DarkModeBg").ignoresSafeArea())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                if !cartData.items.isEmpty {
                    Button(action: {
                        showBottomSheet.toggle()
                    }) {
                        HStack{
                            Text("Оформить")
                            Spacer()
                            Text("\(cartData.totalCount)шт.")
                            Spacer()
                            Text("\(cartData.totalPrice) ₽")
                        }
                        .font(.callout).bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                                .padding(.horizontal, 16)
                    .sheet(isPresented: $showBottomSheet) {
                        OrderView(deliveryData: deliveryData, contactsData: contactsData, cartData: cartData)
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            .background(Color("DarkModeBg").ignoresSafeArea())
            .navigationTitle("Корзина")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if !cartData.items.isEmpty {
                        Button(action: {
                            showClearCartAlert = true
                        }) {
                            Image(systemName: "trash.slash.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                }
            }
            .alert("Очистить корзину?", isPresented: $showClearCartAlert) {
                Button("Отмена", role: .cancel) {}
                Button("Очистить", role: .destructive) {
                    cartData.clearCart()
                }
            } message: {
                Text("Вы уверены, что хотите удалить все товары из корзины?")
            }
        }
    }
}

#Preview {
    CartView(cartData: CartData(), deliveryData: DeliveryData(), contactsData: ContactsData())
}
