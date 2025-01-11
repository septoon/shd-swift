//
//  CartItemRow.swift
//  shd
//
//  Created by Тигран Дарчинян on 03.01.2025.
//

import SwiftUI
import Kingfisher

struct CartItemRow: View {
    let item: MenuItemDTO
    @ObservedObject var cartData: CartData

    var body: some View {
        HStack {
            if let imageUrl = item.image, let url = URL(string: imageUrl) {
                KFImage(url)
                    .placeholder {
                        ProgressView()
                            .frame(width: 50, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 40)
                    .cornerRadius(5)
            }
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.caption2).bold()

                if let gram = item.gram {
                    Text("\(gram) г")
                        .font(.system(size: 8))
                        .foregroundColor(.secondary)
                } else {
                    Text("\(item.serving ?? "")")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: 220, alignment: .leading)
            Spacer(minLength: 30)

            HStack {
                Button(action: {
                    cartData.removeFromCart(item)
                }) {
                    Image(systemName: "minus")
                        .foregroundColor(.main)
                }
                .buttonStyle(PlainButtonStyle())
                if let gram = item.gram {
                    Text("\(gram * item.quantity) г")
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
                    Image(systemName: "plus")
                        .foregroundColor(.main)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Spacer()

            Text("\(item.price * item.quantity) ₽")
                .font(.caption2).bold()
                .frame(maxWidth: 70, alignment: .trailing)
        }
        .padding(.vertical, 6)
    }
}
