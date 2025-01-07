//
//  MenuView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI
import Kingfisher

struct MenuView: View {
    @ObservedObject var cartData: CartData
    @ObservedObject var menuData: MenuData
    @ObservedObject var deliveryData: DeliveryData
    @State private var selectedCategory: String? = "Холодные закуски"
    @State private var isRefreshing = false
    
    private let columns = [
          GridItem(.flexible(), spacing: 16),
          GridItem(.flexible(), spacing: 16)
      ]

    var body: some View {
        let sortedCategories: [String] = {
            let orderedCategories = [
                "Холодные закуски", "Горячие закуски", "Салаты",
                "Паста", "Гарниры", "Порционный шашлык",
                "Блюда на мангале", "Соусы", "Хлеб", "Напитки", "Десерты"
            ]
            return Array(menuData.menuCategories.keys).sorted {
                orderedCategories.firstIndex(of: $0) ?? .max < orderedCategories.firstIndex(of: $1) ?? .max
            }
        }()
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if menuData.isLoading && deliveryData.isLoading {
                        ZStack {
                            Color("DarkModeBg")
                                .ignoresSafeArea()

                            PreLoader(animationName: "Preloader")
                                .frame(width: 100, height: 100)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    } else if let errorMessage = menuData.errorMessage {
                        VStack {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Повторить") {
                                Task {
                                    await menuData.fetchMenuItems()
                                }
                            }
                            .padding()
                            .background(AppColors.main)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    } else {

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(sortedCategories, id: \.self) { category in
                                    Button(action: {
                                        selectedCategory = category
                                    }) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            VStack {
                                                if let firstItem = menuData.menuCategories[category]?.first, let imageUrl = firstItem.image, let url = URL(string: imageUrl) {
                                                    KFImage(url)
                                                        .placeholder {
                                                            ProgressView()
                                                                .frame(width: 70, height: 70)
                                                                .background(Color("DarkModeElBg"))
                                                                .clipShape(Circle())
                                                        }
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 70, height: 70)
                                                        .clipShape(Circle())
                                                        .padding()
                                                }
                                            }
                                            .frame(width: 80, height: 80)
                                            .background(selectedCategory == category ? AppColors.main : Color("DarkModeElBg"))
                                            .clipShape(Circle())
                                            Spacer()
                                            Text(category)
                                                .frame(maxWidth: .infinity)
                                                .font(.footnote).bold()
                                                .foregroundColor(selectedCategory == category ? Color("DarkModeIcon") : AppColors.main)
                                        }
                                        .frame(width: 80, height: 130, alignment: .top)
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        if let selectedCategory = selectedCategory,
                            let items = menuData.menuCategories[selectedCategory] {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(items) { item in
                                    MenuItemView(item: item, cartData: cartData, deliveryData: deliveryData)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .background(Color("DarkModeBg"))
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await menuData.fetchMenuItems()
            }
            .task {
                await menuData.fetchMenuItems()
                await deliveryData.fetchDelivery()
            }
        }
    }
}

#Preview {
    MenuView(cartData: CartData(), menuData: MenuData(), deliveryData: DeliveryData())
}
