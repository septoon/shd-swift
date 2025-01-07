//
//  TelegramService.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let name: String
    let price: Int
    let quantity: Int
    let gram: Int
}

/// Сервис для отправки сообщений в Телеграм
final class TelegramService {
    // Подставьте свой токен и ID
    private let botToken = Bundle.main.object(forInfoDictionaryKey: "TELEGRAM_BOT_TOKEN") as? String ?? ""
    private let chatId = Bundle.main.object(forInfoDictionaryKey: "CHAT_ID") as? String ?? ""
    
    func sendOrder(
        orderIndex: Int,
        currentTime: Date,
        address: String,
        phoneNumber: String,
        comment: String,
        paymentMethod: PaymentMethod,
        cartItems: [MenuItemDTO],
        totalPrice: Int
    ) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "dd.MM HH:mm"
        let dateString = formatter.string(from: currentTime)
        
        let method = (orderIndex == 0) ? "Доставка" : "Самовывоз"
        
        let itemsText = cartItems.map { item in
            let totalItemPrice = item.price * Int(item.quantity)
            return if let gram = item.gram {
                "\(item.name) | x \(gram * item.quantity) г."
            } else {
                "\(item.name) | x \(item.quantity) шт."
            }
            
        }
        .joined(separator: "\n")
        
        let text = """
            *Новый заказ*:
            Способ: \(method)

            *Список товаров:*
            \(itemsText)

            *Общая сумма:* \(Int(totalPrice))₽
            
            Адрес: \(address)
            Телефон: \(phoneNumber)
            Комментарий: \(comment)
            Дата и время: \(dateString)
            Оплата: \(paymentMethod.rawValue)
            """
        
        guard let escapedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return
        }
        
        let urlString = "https://api.telegram.org/bot\(botToken)/sendMessage?chat_id=\(chatId)&text=\(escapedText)&parse_mode=Markdown"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка при отправке в Telegram: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Ответ от Telegram: \(responseString)")
            }
        }
        task.resume()
    }
}

