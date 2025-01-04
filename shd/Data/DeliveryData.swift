//
//  DeliveryData.swift
//  shd
//
//  Created by Тигран Дарчинян on 28.12.2024.
//

import SwiftUI

struct DeliveryDTO: Decodable {
    let paidDelivery: Bool
    let deliveryStart: Int
    let deliveryEnd: Int
    let minDeliveryAmount: Int
    let deliveryCost: Int
    let promotion: Bool
    let promotionCount: Int

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        paidDelivery = try container.decode(Bool.self, forKey: .paidDelivery)
        promotion = try container.decode(Bool.self, forKey: .promotion)

        // Преобразование строки или числа в Int
        deliveryStart = {
            if let stringValue = try? container.decode(String.self, forKey: .deliveryStart),
               let intValue = Int(stringValue) {
                return intValue
            }
            return try! container.decode(Int.self, forKey: .deliveryStart)
        }()

        deliveryEnd = {
            if let stringValue = try? container.decode(String.self, forKey: .deliveryEnd),
               let intValue = Int(stringValue) {
                return intValue
            }
            return try! container.decode(Int.self, forKey: .deliveryEnd)
        }()

        minDeliveryAmount = {
            if let stringValue = try? container.decode(String.self, forKey: .minDeliveryAmount),
               let intValue = Int(stringValue) {
                return intValue
            }
            return try! container.decode(Int.self, forKey: .minDeliveryAmount)
        }()

        deliveryCost = {
            if let stringValue = try? container.decode(String.self, forKey: .deliveryCost),
               let intValue = Int(stringValue) {
                return intValue
            }
            return try! container.decode(Int.self, forKey: .deliveryCost)
        }()

        promotionCount = {
            if let stringValue = try? container.decode(String.self, forKey: .promotionCount),
               let intValue = Int(stringValue) {
                return intValue
            }
            return try! container.decode(Int.self, forKey: .promotionCount)
        }()
    }

    private enum CodingKeys: String, CodingKey {
        case paidDelivery, deliveryStart, deliveryEnd, minDeliveryAmount, deliveryCost, promotion, promotionCount
    }
}

final class DeliveryData: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var delivery: DeliveryDTO?

    func fetchDelivery() async {
        do {
            await MainActor.run {
                self.isLoading = true
                self.errorMessage = nil
            }

            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
                fatalError("API_BASE_URL is not set in Info.plist")
            }
            let urlString = "\(baseUrl)/delivery.json"
            guard let url = URL(string: urlString) else {
                await MainActor.run {
                    self.errorMessage = "Неверный URL"
                }
                return
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            let dtos = try decoder.decode(DeliveryDTO.self, from: data)

            await MainActor.run {
                self.delivery = dtos
                self.isLoading = false
            }

        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
