//
//  CartItemRow.swift
//  shd
//
//  Created by Тигран Дарчинян on 03.01.2025.
//

import SwiftUI

struct CartItemRow: View {
    let item: MenuItemDTO
    @ObservedObject var cartData: CartData

    var body: some View {
        HStack {
            if let imageUrl = item.image, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 30)
                            .cornerRadius(5)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            Text(item.name)
                .font(.caption2).bold()
                .frame(alignment: .leading)

            Spacer()

            HStack {
                Button(action: {
                    cartData.removeFromCart(item)
                }) {
                    Image(systemName: "minus.circle")
                        .foregroundColor(.red)
                }
                
                if item.gram != nil {
                    Text("\((item.gram ?? 0) * item.quantity)")
                        .font(.caption2)
                        .padding(.horizontal, 5)
                } else {
                    Text("\(item.quantity)")
                        .font(.caption2)
                        .padding(.horizontal, 5)
                }
                
                Button(action: {
                    cartData.addToCart(item)
                }) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.green)
                }
                Text("\(item.price * item.quantity) ₽")
                    .font(.caption2)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("DarkModeElBg"))
        )
    }
}
