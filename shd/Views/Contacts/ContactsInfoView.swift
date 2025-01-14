//
//  ContactsInfoView.swift
//  shd
//
//  Created by Тигран Дарчинян on 12.01.2025.
//

import SwiftUI

public struct ContactsInfoView: View {
    @ObservedObject var contactsData: ContactsData
    var onCallPhoneNumber: (String) -> Void
    public var body: some View {
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
                                onCallPhoneNumber(c.phoneNumber)
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
        .background(.clear)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
