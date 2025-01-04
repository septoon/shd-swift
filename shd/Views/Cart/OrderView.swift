//
//  OrderView.swift
//  shd
//
//  Created by Тигран Дарчинян on 03.01.2025.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var cartData: CartData
    @State var orderIndex = 0
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.orderIndex = 0
                }) {
                    Text("Доставка")
                        .foregroundColor(orderIndex == 0 ? .white : .black)
                        .font(.caption2).bold()
                        .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 2))
                
                Button(action: {
                    self.orderIndex = 1
                }) {
                    Text("Самовывоз")
                        .foregroundColor(orderIndex == 1 ? .white : .black)
                        .font(.caption2).bold()
                        .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 2))
            }
            .padding()
            .background(
                ZStack {
                    Color.white
                        .cornerRadius(6)
                        .frame(width: (UIScreen.main.bounds.width / 2 - 10), height: 30)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.black)
                        .frame(width: (UIScreen.main.bounds.width / 2 - 20) / 2, height: 25)
                        .offset(x: orderIndex == 0 ? -(UIScreen.main.bounds.width / 2 - 20) / 4 : (UIScreen.main.bounds.width / 2 - 20) / 4)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5), value: orderIndex)
                }
            )
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 10)
                ForEach(cartData.items, id: \.id) { item in
                    HStack {
                        Text(item.name)
                            .font(.caption2).bold()

                        Spacer()
                            
                        if item.gram != nil {
                            Text("\((item.gram ?? 0) * item.quantity)")
                                .font(.caption2)
                        } else {
                            Text("\(item.quantity)")
                                .font(.caption2)
                        }
                        
                        Spacer()
                        
                        Text("\(item.price * item.quantity) ₽")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 10)
                    Spacer()
                        .frame(height: 5)
                }

                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("DarkModeElBg"))
            )
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("DarkModeBg"))
    }
}
