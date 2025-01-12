//
//  MenuItemButton.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct MenuItemButton: View {
    let item: MenuItemDTO
    let discountPrice: Int
    @ObservedObject var cartData: CartData
    @ObservedObject var deliveryData: DeliveryData
    var body: some View {
        if item.onStop == true {
            ZStack {
                Text("Недоступно")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color("LightSlateGray"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
        } else {
            Button(action: {
                withAnimation {
                    if cartData.items.first(where: { $0.id == item.id }) == nil {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        var newItem = item
                        newItem.price = discountPrice
                        cartData.addToCart(newItem)
                    }
                }
            }) {
                ZStack {
                    if let cartItem = cartData.items.first(where: { $0.id == item.id }) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    cartData.removeFromCart(item)
                                }
                            }) {
                                Image(systemName: "minus")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(Color("Main"))
                                    .font(.body)
                            }
                            Spacer()
                            Text("\(cartItem.quantity)")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .font(.subheadline)
                                .foregroundColor(Color("Main"))
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    var newItem = item
                                    newItem.price = discountPrice
                                    cartData.addToCart(newItem)
                                }
                            }) {
                                Image(systemName: "plus")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(Color("Main"))
                                    .font(.body)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(Color("VeryDarkGray"))
                        .cornerRadius(8)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.3), value: cartData.items)
                    } else {
                        Text("Добавить")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(Color("Main"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .trailing).combined(with: .opacity)
                            ))
                            .animation(.easeInOut(duration: 0.3), value: cartData.items)
                    }
                }
                .cornerRadius(8)
                .frame(maxWidth: .infinity)
                .clipped()
            }
        }
    }
}
