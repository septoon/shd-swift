//
//  ContactsView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var contactsData: ContactsData
    
    func callPhoneNumber(_ phoneNumber: String) {
        let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        if let phoneURL = URL(string: "tel://\(cleanedPhoneNumber)"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Не удалось открыть приложение телефона.")
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let c = contactsData.contact {
                        // Карточка с контактами
                        VStack(alignment: .leading, spacing: 4) {
                            // Телефон
                            HStack(alignment: .bottom, spacing: 12) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Телефон:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Button(action: {
                                        callPhoneNumber(c.phoneNumber)
                                    }) {
                                        Text(c.phoneNumber)
                                            .foregroundColor(.blue)
                                            .fontWeight(.bold)
                                    }
                                }
                                Spacer()
                            }
                            
                            // Адрес
                            HStack(alignment: .bottom, spacing: 12) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 28))
                                    .foregroundColor(.teal)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Адрес:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text(c.address)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                            }
                            
                            // Режим работы
                            HStack(alignment: .bottom, spacing: 12) {
                                Image(systemName: "clock.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(.green)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Режим работы:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(c.scheduleStart):00 - \(c.scheduleEnd):00")
                                        .fontWeight(.bold)
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkModeElBg"))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    } else {
                        if contactsData.errorMessage != nil {
                            Text("Ошибка: \(contactsData.errorMessage!)")
                                .foregroundColor(.red)
                        } else {
                            ZStack {
                                Color("DarkModeBg")
                                    .ignoresSafeArea()

                                PreLoader(animationName: "Preloader")
                                    .frame(width: 100, height: 100)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            }
            .background(Color("DarkModeBg").ignoresSafeArea())
            .navigationTitle("Контакты")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await contactsData.fetchContacts()
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(contactsData: ContactsData())
    }
}
