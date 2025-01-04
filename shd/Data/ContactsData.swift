//
//  ContactsData.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

// DTO для данных контактов
struct ContactDTO: Decodable {
    let phoneNumber: String
    let address: String
    let scheduleStart: Int
    let scheduleEnd: Int
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
            address = try container.decode(String.self, forKey: .address)
            // Обработка числовых значений
            if let scheduleStartString = try? container.decode(String.self, forKey: .scheduleStart),
               let scheduleStartInt = Int(scheduleStartString) {
                scheduleStart = scheduleStartInt
            } else {
                scheduleStart = try container.decode(Int.self, forKey: .scheduleStart)
            }

            if let scheduleEndString = try? container.decode(String.self, forKey: .scheduleEnd),
               let scheduleEndInt = Int(scheduleEndString) {
                scheduleEnd = scheduleEndInt
            } else {
                scheduleEnd = try container.decode(Int.self, forKey: .scheduleEnd)
            }
        }

        private enum CodingKeys: String, CodingKey {
            case phoneNumber, address, scheduleStart, scheduleEnd
        }
}

final class ContactsData: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var contact: ContactDTO?

    func fetchContacts() async {
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String else {
                fatalError("API_BASE_URL is not set in Info.plist")
            }
            let urlString = "\(baseUrl)/contacts.json"
            guard let url = URL(string: urlString) else {
                await MainActor.run {
                    self.errorMessage = "Неверный URL"
                    self.isLoading = false
                }
                return
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            let dtos = try decoder.decode(ContactDTO.self, from: data)

            await MainActor.run {
                self.contact = dtos
                self.isLoading = false
            }

        } catch let error as URLError {
            await MainActor.run {
                self.errorMessage = "Ошибка загрузки: \(error.localizedDescription)"
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Не удалось обработать данные: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
