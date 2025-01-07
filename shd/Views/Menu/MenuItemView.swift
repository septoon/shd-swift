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
        let discountPrice: Int = {
            if let delivery = deliveryData.delivery {
                if delivery.promotion {
                    let discountedPrice = Double(item.price) * (1 - Double(delivery.promotionCount) / 100.0)
                    return max(0, Int(discountedPrice))
                }
            }
            return item.price
        }()

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
                        VStack(alignment: .leading) {
                            Text(item.options ?? "")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                            Text("Приблизительный вес: \(item.weight ?? 0)г.")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                    } else if item.serving != nil {
                        Text("\( item.serving ?? "")")
                            .font(.body)
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
                            Text("\(discountPrice) ₽")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(AppColors.main)
                        }
                    } else {
                        Text("\(item.price) ₽")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.main)
                    }
                }
                
                MenuItemButton(item: item, discountPrice: discountPrice, cartData: cartData, deliveryData: deliveryData)            }
        }
        .background(.clear)
        .cornerRadius(10)
    }
}
