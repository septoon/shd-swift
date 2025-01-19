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
        
        var suggestions: [String] {
            let allItems = menuData.menuCategories.values.flatMap { $0 }
            return allItems
                .filter { $0.name.localizedCaseInsensitiveContains(searchText) }
                .map { $0.name }
        }

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
                            MenuCategoriesView(sortedCategories: sortedCategories, selectedCategory: $selectedCategory, menuData: menuData)
                            
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
            .onTapGesture {
                hideKeyboard()
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Поиск по меню") {
                List {
                    Section {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Text(suggestion).searchCompletion(suggestion)
                                .foregroundColor(Color("DarkModeText"))
                                
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                    
            }
            .background(Color("DarkModeBg").edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Image("titleLogo1line")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(height: 16)
                        .foregroundStyle(Color("DarkModeText"))
                        .padding(.bottom, 10)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 26)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 10)
                    }
                }
            }
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
