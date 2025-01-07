//
//  OrderTypeSwitcher.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct OrderTypeSwitcher: View {
    @Binding var orderIndex: Int
    
    var body: some View {
        HStack {
            Button(action: {
                self.orderIndex = 0
            }) {
                Text("Доставка")
                    .foregroundColor(orderIndex == 0 ? .white : .main)
                    .font(.caption2).bold()
                    .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 2))
            
            Button(action: {
                self.orderIndex = 1
            }) {
                Text("Самовывоз")
                    .foregroundColor(orderIndex == 1 ? .white : .main)
                    .font(.caption2).bold()
                    .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 2))
        }
        .padding()
        .background(
            ZStack {
                Color("DarkModeElBg")
                    .cornerRadius(6)
                    .frame(width: (UIScreen.main.bounds.width / 2 - 10), height: 30)

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.main)
                    .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2, height: 25)
                    .offset(x: orderIndex == 0 ? -(UIScreen.main.bounds.width / 2 - 20) / 4 : (UIScreen.main.bounds.width / 2 - 20) / 4)
                    .animation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5), value: orderIndex)
            }
        )
    }
}
