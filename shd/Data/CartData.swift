//
//  CartData.swift
//  shd
//
//  Created by Тигран Дарчинян on 30.12.2024.
//

import SwiftUI

final class CartData: ObservableObject {
    @Published var items: [MenuItemDTO] = []

    func addToCart(_ item: MenuItemDTO) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
        } else {
            var newItem = item
            newItem.quantity = 1
            items.append(newItem)
        }
    }

    func removeFromCart(_ item: MenuItemDTO) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
    }

    var totalPrice: Int {
        items.reduce(0) { $0 + ($1.price * $1.quantity) }
    }
    
    var totalCount: Int {
        items.reduce(0) { $1.gram != nil ? $0 + 1 : $0 + $1.quantity }
    }
}
