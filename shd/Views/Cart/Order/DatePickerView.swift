//
//  DatePickerView.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var currentTime: Date
    @Binding var orderIndex: Int
    
    @ObservedObject var deliveryData: DeliveryData
    @ObservedObject var contactsData: ContactsData

    var body: some View {
        DatePicker(
            "Время",
            selection: Binding<Date>(
                get: { currentTime },
                set: { newValue in
                    currentTime = validateTime(newValue)
                }
            ),
            displayedComponents: [.date, .hourAndMinute]
        )
    }

    private func validateTime(_ newValue: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: newValue)

        let dS = deliveryData.delivery?.deliveryStart ?? 10
        let dE = deliveryData.delivery?.deliveryEnd ?? 22
        let cS = contactsData.contact?.scheduleStart ?? 10
        let cE = contactsData.contact?.scheduleEnd ?? 23

        if orderIndex == 0 {
            if hour < dS {
                return calendar.date(bySettingHour: dS, minute: 0, second: 0, of: newValue) ?? newValue
            } else if hour > dE {
                return calendar.date(bySettingHour: dE, minute: 0, second: 0, of: newValue) ?? newValue
            } else {
                return newValue
            }
        } else {
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
