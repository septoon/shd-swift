//
//  MenuData.swift
//  shd
//
//  Created by Тигран Дарчинян on 29.12.2024.
//

import SwiftUI

// DTO для элемента меню
struct MenuItemDTO: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let price: Int
    let serving: String?
    let description: String?
    let options: String?
    let gram: Int?
    let weight: Int?
    let image: String?
    let onStop: Bool
    let isChange: Bool
    var quantity: Int = 0

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Int.self, forKey: .price)
        serving = try container.decodeIfPresent(String.self, forKey: .serving)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        options = try container.decodeIfPresent(String.self, forKey: .options)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        onStop = try container.decodeIfPresent(Bool.self, forKey: .onStop) ?? false
        isChange = try container.decodeIfPresent(Bool.self, forKey: .isChange) ?? false

        // Обработка gram
        gram = {
            if let gramString = try? container.decode(String.self, forKey: .gram),
               let gramInt = Int(gramString) {
                return gramInt
            }
            return try? container.decodeIfPresent(Int.self, forKey: .gram)
        }()

        // Обработка weight
        weight = {
            if let weightString = try? container.decode(String.self, forKey: .weight),
               let weightInt = Int(weightString) {
                return weightInt
            }
            return try? container.decodeIfPresent(Int.self, forKey: .weight)
        }()
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, price, serving, description, options, gram, weight, image, onStop, isChange
    }
}

final class MenuData: ObservableObject {
    @AppStorage("menuCategories") private var menuCategoriesData: Data?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var menuCategories: [String: [MenuItemDTO]] = [:]

    func fetchMenuItems() async {
        if let savedData = menuCategoriesData, !savedData.isEmpty {
            do {
                let decodedCategories = try JSONDecoder().decode([String: [MenuItemDTO]].self, from: savedData)
                await MainActor.run {
                    self.menuCategories = decodedCategories

                }
                return
            } catch {
                print("Ошибка декодирования сохраненных данных: \(error)")
            }
        }

        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
                await MainActor.run {
                    self.errorMessage = "Ошибка: отсутствует API_BASE_URL в Info.plist"
                    self.isLoading = false
                }
                return
            }

            let urlString = "\(baseUrl)/data.json"
            guard let url = URL(string: urlString) else {
                await MainActor.run {
                    self.errorMessage = "Неверный URL"
                    self.isLoading = false
                }
                return
            }

            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            let categories = try decoder.decode([String: [MenuItemDTO]].self, from: data)

            await MainActor.run {
                self.menuCategories = categories
                self.isLoading = false

                // Сохраняем данные в AppStorage
                saveMenuCategories(categories)
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    private func saveMenuCategories(_ categories: [String: [MenuItemDTO]]) {
        do {
            let data = try JSONEncoder().encode(categories)
            menuCategoriesData = data
        } catch {
            print("Ошибка сохранения данных: \(error)")
        }
    }
}
