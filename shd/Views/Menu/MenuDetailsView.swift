//
//  MenuDetailsView.swift
//  shd
//
//  Created by Тигран Дарчинян on 18.01.2025.
//

import SwiftUI
import Kingfisher

struct MenuDetailsView: View {
    let item: MenuItemDTO
    @ObservedObject var cartData: CartData
    @ObservedObject var deliveryData: DeliveryData
    @Binding var isPresented: Bool
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
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    if let imageUrl = item.image, let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2.5)
                                    .cornerRadius(10)
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 2.5)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(
                                color: Color("DarkModeShadow"),
                                radius: 10,
                                x: 0,
                                y: 12
                            )
                    }
                }
                    
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Spacer(minLength: 20)
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .foregroundColor(Color("DarkModeText"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(1)
                                .padding(.bottom, 10)
                       
                            Text(item.description ?? "")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .padding(.bottom, 20)

                            if item.gram != nil {
                                VStack(alignment: .leading) {
                                    Text(item.options ?? "")
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                    Text("Приблизительный вес: \(item.weight ?? 0)г.")
                                        .font(.title3)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                .padding(.bottom, 10)
                            } else if item.serving != nil {
                                Text("\( item.serving ?? "")")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .padding(.bottom, 10)
                            }
                            if deliveryData.delivery?.promotion == true {
                                VStack(alignment: .leading) {
                                    Text("\(item.price) ₽")
                                        .strikethrough()
                                        .font(.body)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                    Text("\(discountPrice) ₽")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(AppColors.main)
                                }
                            } else {
                                Text("\(item.price) ₽")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.main)
                            }
                        }
                        Spacer(minLength: 20)
                        
                    }
                }
                Spacer(minLength: 80)
                HStack {
                    Spacer(minLength: 40)
                    MenuItemButton(item: item, discountPrice: discountPrice, cartData: cartData, deliveryData: deliveryData)
                        .shadow(
                            color: Color("DarkModeShadow"),
                            radius:6,
                            x: 0,
                            y: 6
                        )
                    Spacer(minLength: 40)
                }
                Spacer(minLength: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("DarkModeBg")
            .edgesIgnoringSafeArea(.all))
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 32)
                            .foregroundStyle(Color("SilverAdmin"))
                            .shadow(radius: 4)
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
