//
//  MenuView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct MenuView: View {
//    @StateObject var cartData = CartData()
    @ObservedObject var cartData: CartData
//    @StateObject private var menuData = MenuData()
    @ObservedObject var menuData: MenuData
//    @StateObject private var deliveryData = DeliveryData()
    @ObservedObject var deliveryData: DeliveryData
    @State private var selectedCategory: String? = "Холодные закуски"
    @State private var isRefreshing = false

    var body: some View {
        let orderedCategories = ["Холодные закуски", "Горячие закуски", "Салаты", "Паста", "Гарниры", "Порционный шашлык", "Блюда на мангале", "Соусы", "Хлеб", "Напитки", "Десерты"]
        let sortedCategories = Array(menuData.menuCategories.keys).sorted {
            orderedCategories.firstIndex(of: $0) ?? .max < orderedCategories.firstIndex(of: $1) ?? .max
        }
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if menuData.isLoading && deliveryData.isLoading {
                        ZStack {
                            Color("DarkModeBg")
                                .ignoresSafeArea()

                            ProgressView("Загрузка меню...")
                                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.main))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                                        AsyncImage(url: url) { phase in
                                                            switch phase {
                                                            case .empty:
                                                                ProgressView()
                                                                    .frame(width: 70, height: 70)
                                                                    .background(Color("DarkModeElBg"))
                                                                    .clipShape(Circle())
                                                                    .padding()
                                                            case .success(let image):
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                                    .frame(width: 70, height: 70)
                                                                    .clipShape(Circle())
                                                                    .padding()
                                                            case .failure:
                                                                Image(systemName: "photo")
                                                                    .resizable()
                                                                    .scaledToFit()
                                                                    .frame(width: 70, height: 70)
                                                                    .background(Color("DarkModeElBg"))
                                                                    .clipShape(Circle())
                                                                    .padding()
                                                            @unknown default:
                                                                EmptyView()
                                                            }
                                                        }
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
                            LazyVStack(alignment: .leading, spacing: 16) {
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


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(cartData: CartData(), menuData: MenuData(), deliveryData: DeliveryData())
    }
}
