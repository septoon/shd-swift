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
    var body: some View {
        TabView {
            NavigationView {
                MenuView(cartData: cartData, menuData: menuData, deliveryData: deliveryData)
            }
            .tabItem {
                Label("Меню", systemImage: "house.circle")
                    
            }
            NavigationView {
                DeliveryView(deliveryData: deliveryData)
            }
            .tabItem {
                Label("Доставка", systemImage: "car.circle")
                    
            }
            NavigationView {
                ContactsView(contactsData: contactsData)
            }
            .tabItem {
                Label("Контакты", systemImage: "person.crop.circle")
                    
            }
            NavigationView {
                CartView(cartData: cartData)
            }
            .tabItem {
                Label("Корзина", systemImage: "cart.circle")
            }
            .badge(cartData.totalCount)
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
