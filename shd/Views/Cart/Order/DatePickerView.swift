//
//  DatePickerView.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct DatePickerView: View {
    /// Текущее выбранное время
    @Binding var currentTime: Date
    
    /// Индекс заказа (0 - доставка, 1 - самовывоз)
    @Binding var orderIndex: Int
    
    /// Данные по доставке (deliveryStart, deliveryEnd)
    @ObservedObject var deliveryData: DeliveryData
    
    /// Данные по самовывозу (scheduleStart, scheduleEnd)
    @ObservedObject var contactsData: ContactsData

    var body: some View {
        DatePicker(
            "Время",
            selection: Binding<Date>(
                get: { currentTime },
                set: { newValue in
                    // Проверяем, что выбранное время попадает в нужный интервал
                    currentTime = validateTime(newValue)
                }
            ),
            displayedComponents: [.date, .hourAndMinute]
        )
        .padding(.vertical, 4)
    }

    /// Проверяем время «на лету» — если оно вышло за границы, подрезаем
    private func validateTime(_ newValue: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: newValue)

        // Значения по умолчанию (на всякий случай)
        let dS = deliveryData.delivery?.deliveryStart ?? 10
        let dE = deliveryData.delivery?.deliveryEnd ?? 22
        let cS = contactsData.contact?.scheduleStart ?? 10
        let cE = contactsData.contact?.scheduleEnd ?? 23

        // Логика «зажимания» часов
        if orderIndex == 0 { // Доставка
            if hour < dS {
                return calendar.date(bySettingHour: dS, minute: 0, second: 0, of: newValue) ?? newValue
            } else if hour > dE {
                return calendar.date(bySettingHour: dE, minute: 0, second: 0, of: newValue) ?? newValue
            } else {
                return newValue
            }
        } else { // Самовывоз
            if hour < cS {
                return calendar.date(bySettingHour: cS, minute: 0, second: 0, of: newValue) ?? newValue
            } else if hour > cE {
                return calendar.date(bySettingHour: cE, minute: 0, second: 0, of: newValue) ?? newValue
            } else {
                return newValue
            }
        }
    }
}
