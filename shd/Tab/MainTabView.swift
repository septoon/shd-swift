//
//  MainTabView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var menuData = MenuData()
    @StateObject private var deliveryData = DeliveryData()
    @StateObject private var contactsData = ContactsData()
    @StateObject private var cartData = CartData()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MenuView(cartData: cartData, menuData: menuData, deliveryData: deliveryData)
            }
            .tabItem {
                Label("Меню", systemImage: "house.circle")
            }
            .tag(0)
            
            NavigationView {
                DeliveryView(deliveryData: deliveryData)
            }
            .tabItem {
                Label("Доставка", systemImage: "car.circle")
            }
            .tag(1)
            
            NavigationView {
                ContactsView(contactsData: contactsData)
            }
            .tabItem {
                Label("Контакты", systemImage: "person.crop.circle")
            }
            .tag(2)
            
            NavigationView {
                CartView(cartData: cartData, deliveryData: deliveryData, contactsData: contactsData)
            }
            .tabItem {
                Label("Корзина", systemImage: "cart.circle")
            }
            .tag(3)
            .badge(cartData.totalCount)
        }
        .onChange(of: selectedTab) { _ in
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .background(Color(.systemBackground))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
