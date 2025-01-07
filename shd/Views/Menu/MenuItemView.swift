//
//  MenuItemView.swift
//  shd
//
//  Created by Тигран Дарчинян on 29.12.2024.
//

import SwiftUI
import Kingfisher

struct MenuItemView: View {
    let item: MenuItemDTO
//    @StateObject private var deliveryData = DeliveryData()
    @ObservedObject var cartData: CartData
    @ObservedObject var deliveryData: DeliveryData

    var body: some View {
        VStack {
            if let imageUrl = item.image, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                            .cornerRadius(10)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(10)
            }

            // Текстовые данные блюда
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                if item.gram != nil {
                    Text(item.options ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Text("Приблизительный вес: \(item.weight ?? 0)г.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                } else if item.serving != nil {
                    Text("Количество: \( item.serving ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
                HStack(alignment: .bottom) {
                    if deliveryData.delivery?.promotion == true {
                        VStack(alignment: .leading) {
                                            Text("\(item.price) ₽")
                                                .strikethrough()
                                                .font(.footnote)
                                                .fontWeight(.light)
                                                .foregroundColor(.gray)
                                            Text("\(item.price - deliveryData.delivery!.promotionCount) ₽")
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .foregroundColor(AppColors.main)
                                        }
                                    } else {
                                        Text("\(item.price) ₽")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(AppColors.main)
                                    }
                                    Spacer()
                                    Button(action: {
                                        withAnimation {
                                            if cartData.items.first(where: { $0.id == item.id }) == nil {
                                                 cartData.addToCart(item)
                                            }
                                        }
                                    }) {
                                        ZStack {
                                            if let cartItem = cartData.items.first(where: { $0.id == item.id }) {
                                                HStack {
                                                    Button(action: {
                                                        withAnimation {
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
                                                            cartData.addToCart(item)
                                                        }
                                                    }) {
                                                        Image(systemName: "plus")
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                            .foregroundColor(Color("Main"))
                                                            .font(.body)
                                                    }
                                                }
                                                .padding(.horizontal, 6)
                                                .frame(width: 90, height: 34)
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
                                                    .padding(.horizontal, 12)
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
                                    }
                }
                .frame(maxWidth: .infinity)
                
                
            }
            .padding(.leading, 2)
        }
        .padding()
        .background(Color("DarkModeElBg"))
        .cornerRadius(10)
    }
}
