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
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
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
        
        
        let allItems: [MenuItemDTO] = {
            return menuData.menuCategories.values.flatMap { $0 }
        }()

        let filteredItems: [MenuItemDTO] = {
            if !searchText.isEmpty {
                return allItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            } else if let selectedCategory = selectedCategory {
                return menuData.menuCategories[selectedCategory] ?? []
            } else {
                return []
            }
        }()

        var isLoading: Bool {
            menuData.isLoading || deliveryData.isLoading
        }
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if isLoading {
                        var isLoading: Bool {
                            menuData.isLoading || deliveryData.isLoading
                        }
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

                        if searchText.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(sortedCategories, id: \.self) { category in
                                        Button(action: {
                                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                            selectedCategory = category
                                        }) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                ZStack {
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
                                                                .opacity(selectedCategory == category ? 1 : 0.2)
                                                                .transition(.slide)
                                                                .clipShape(Circle())
                                                                .padding()
                                                        }
                                                    }
                                                    .frame(width: 80, height: 70)
                                                    .clipShape(Circle())
                                                }
                                                Spacer()
                                                Text(category)
                                                    .frame(maxWidth: .infinity)
                                                    .font(.footnote).bold()
                                                    .foregroundColor(selectedCategory == category ? Color("DarkModeText") : Color("DarkModeIcon"))
                                            }
                                            .frame(width: 80, height: 130, alignment: .top)
                                            .shadow(
                                                    color: selectedCategory == category ? Color("DarkModeShadow") : .clear,
                                                    radius: selectedCategory == category ? 20 : 0,
                                                    x: 0,
                                                    y: selectedCategory == category ? 22 : 0
                                                    )
                                            .transition(.opacity.combined(with: .slide))
                                            .animation(.easeInOut(duration: 0.1), value: selectedCategory)
                                        }
                                    }
                                }
                                .padding()
                            }
                            
                        }
                        
                        if !filteredItems.isEmpty {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(filteredItems) { item in
                                    MenuItemView(item: item, cartData: cartData, deliveryData: deliveryData)
                                }
                            }
                            .padding()
                        } else {
                            VStack {
                                Spacer(minLength: 200)
                                PreLoader(animationName: "Preloader")
                                    .frame(width: 100, height: 100)
                                Spacer()
                            }
                            .background(Color("DarkModeBg")
                                .ignoresSafeArea())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                        }
                    }
                }
            }
            .background(Color("DarkModeBg"))
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("Меню")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .environment(\.locale, Locale(identifier: "ru"))
            .refreshable {
                await menuData.fetchMenuItems()
            }
            .task {
                await menuData.fetchMenuItems()
                await deliveryData.fetchDelivery()
            }
        }
    }
    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

#Preview {
    MenuView(cartData: CartData(), menuData: MenuData(), deliveryData: DeliveryData())
}
