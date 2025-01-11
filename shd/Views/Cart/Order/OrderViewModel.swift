//
//  OrderViewModel.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cash = "Наличные"
    case card = "Банковская карта"

    var id: String { self.rawValue }
}

class OrderViewModel: ObservableObject {
    
    @Published var orderIndex: Int = 0
    @Published var currentTime: Date = Date()
    @Published var address: String = ""
    @Published var phoneNumber: String = "+7"
    @Published var comment: String = ""
    @Published var paymentMethod: PaymentMethod = .cash
    
    @Published var orderSent: Bool = false
    @Published var isLoading: Bool = false
    
    @ObservedObject var deliveryData: DeliveryData
    @ObservedObject var contactsData: ContactsData
    @ObservedObject var cartData: CartData
    
    let baseURL: String = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    
    init(deliveryData: DeliveryData,
         contactsData: ContactsData,
         cartData: CartData)
    {
        self.deliveryData = deliveryData
        self.contactsData = contactsData
        self.cartData = cartData
    }
    
    
    var paid: Bool {
       return deliveryData.delivery?.paidDelivery ?? false
    }
    
    var deliveryCost: Int {
        return deliveryData.delivery?.deliveryCost ?? 0
    }
    
    var minAmount: Int {
        return deliveryData.delivery?.minDeliveryAmount ?? 0
    }
    
    var totalPrice: Int {
        return cartData.totalPrice
    }
    
    var isTimeValid: Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentTime)
        
        if orderIndex == 0 {  // доставка
            let dS = deliveryData.delivery?.deliveryStart ?? 10
            let dE = deliveryData.delivery?.deliveryEnd ?? 22
            return (hour >= dS && hour <= dE)
        } else {             // самовывоз
            let cS = contactsData.contact?.scheduleStart ?? 10
            let cE = contactsData.contact?.scheduleEnd ?? 23
            return (hour >= cS && hour <= cE)
        }
    }
    
    var canSendOrder: Bool {
        guard isTimeValid else { return false }
        
        let phoneIsValid = (phoneNumber.count > 15)
        if !phoneIsValid { return false }
        
        if orderIndex == 0 {
            if address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
        }
        
        return true
    }
    
    func clampTime(to newValue: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: newValue)
        
        let dS = deliveryData.delivery?.deliveryStart ?? 10
        let dE = deliveryData.delivery?.deliveryEnd ?? 22
        let cS = contactsData.contact?.scheduleStart ?? 10
        let cE = contactsData.contact?.scheduleEnd ?? 23
        
        if orderIndex == 0 { // доставка
            if hour < dS {
                return calendar.date(bySettingHour: dS, minute: 0, second: 0, of: newValue) ?? newValue
            } else if hour > dE {
                return calendar.date(bySettingHour: dE, minute: 0, second: 0, of: newValue) ?? newValue
            } else {
                return newValue
            }
        } else { // самовывоз
            if hour < cS {
                return calendar.date(bySettingHour: cS, minute: 0, second: 0, of: newValue) ?? newValue
            } else if hour > cE {
                return calendar.date(bySettingHour: cE, minute: 0, second: 0, of: newValue) ?? newValue
            } else {
                return newValue
            }
        }
    }
    
    func sendOrder() {
        guard !isLoading else { return }
        isLoading = true
        
        let telegramService = TelegramService()
        telegramService.sendOrder(
            orderIndex: orderIndex,
            currentTime: currentTime,
            address: address,
            phoneNumber: phoneNumber,
            comment: comment,
            paymentMethod: paymentMethod,
            cartItems: cartData.items,
            totalPrice: cartData.totalPrice
        )
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.cartData.clearCart()
            self.orderSent = true
            self.isLoading = false
        }
    }
}
