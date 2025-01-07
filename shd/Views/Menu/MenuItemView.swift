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
    @ObservedObject var cartData: CartData
    @ObservedObject var deliveryData: DeliveryData

    var body: some View {
        VStack {
            GeometryReader { geometry in
                if let imageUrl = item.image, let url = URL(string: imageUrl) {
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.875)
                                .cornerRadius(10)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.875)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            .frame(height: 140)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(1)
                
                HStack(alignment: .bottom) {
                    if item.gram != nil {
                        Text(item.options ?? "")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                        Text("Приблизительный вес: \(item.weight ?? 0)г.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    } else if item.serving != nil {
                        Text("\( item.serving ?? "")")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                    }
                    Spacer()
                    if deliveryData.delivery?.promotion == true {
                        VStack(alignment: .leading) {
                                Text("\(item.price) ₽")
                                    .strikethrough()
                                    .font(.caption)
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                                Text("\(item.price - deliveryData.delivery!.promotionCount) ₽")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.main)
                            }
                        } else {
                            Text("\(item.price) ₽")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.main)
                        }

                }
                
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
        .background(.clear)
        .cornerRadius(10)
    }
}
