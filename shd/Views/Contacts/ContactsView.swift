//
//  ContactsView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var contactsData: ContactsData
    @State private var isLoading = true
    
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
            ZStack {
                if isLoading {
                    ZStack {
                        Color("DarkModeBg")
                            .ignoresSafeArea()

                        PreLoader(animationName: "Preloader")
                            .frame(width: 100, height: 100)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        MapView(contactsData: contactsData)
                            .ignoresSafeArea(edges: .top)

                        VStack {
                            VStack {
                                Spacer(minLength: 10)
                                ContactsInfoView(
                                    contactsData: contactsData,
                                    onCallPhoneNumber: callPhoneNumber
                                )
                                Spacer()
                            }
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .padding()
                            .frame(maxHeight: UIScreen.main.bounds.height * 0.25)
                            .shadow(radius: 8)
                        }
                    }
                    Spacer(minLength: 30)
                }
            }
            .navigationTitle("Контакты")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await contactsData.fetchContacts()
                isLoading = contactsData.contact == nil
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(contactsData: ContactsData())
    }
}
