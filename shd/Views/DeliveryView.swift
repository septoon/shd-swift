//
//  DeliveryView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct DeliveryView: View {
//    @StateObject private var deliveryData = DeliveryData()
    @ObservedObject var deliveryData: DeliveryData
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // Если идёт загрузка
                if deliveryData.isLoading {
                    ProgressView("Загрузка...")
                        .padding()
                        
                // Если есть ошибка
                } else if let error = deliveryData.errorMessage {
                    VStack(spacing: 16) {
                        Text("Ошибка: \(error)")
                            .foregroundColor(.red)
                        Button("Повторить") {
                            Task {
                                await deliveryData.fetchDelivery()
                            }
                        }
                    }
                    .padding()
                    
                // Если данные пришли
                } else if let d = deliveryData.delivery {
                    
                    VStack(spacing: 16) {
                        // Основной блок (Card)
                        VStack(alignment: .leading, spacing: 10) {
                            if d.paidDelivery {
                                Text("Если сумма заказа превышает \(d.minDeliveryAmount)р, доставка по городу бесплатная!")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                Text("Если сумма заказа меньше \(d.minDeliveryAmount)р, стоимость доставки по городу – \(d.deliveryCost)р.")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            } else {
                                Text("Минимальная сумма заказа для оформления доставки – \(d.minDeliveryAmount)р.")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                Text("Стоимость доставки по городу – бесплатная!")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                Text("Если сумма заказа составляет менее \(d.minDeliveryAmount)р, можете оформить самовывоз.")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }
                            Text("Режим работы доставки: \(d.deliveryStart):00 – \(d.deliveryEnd):00.")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkModeElBg"))
                        .cornerRadius(12)
                        
                        // Блок со скидкой
                        if d.promotion {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("СКИДКА \(d.promotionCount)%")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.blue)
                                Text("На доставку и самовывоз!")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkModeElBg"))
                            .cornerRadius(12)
                        }
                        
                        // Инструкция по оформлению заказа
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Для осуществления заказа Вам необходимо:")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("""
                                 1. Оформить заказ на сайте: выбрать интересующие вас блюда в меню, \
                                 добавить их в корзину, заполнить контактные данные в диалоговом \
                                 окне и оформить заказ.
                                 """)
                                .font(.callout)
                            
                            Text("""
                                 2. Или позвонить по номеру (укажите здесь контактный номер).
                                 После получения заявки, в течение 10 минут, наш менеджер свяжется \
                                 с вами для подтверждения заказа.
                                 """)
                                .font(.callout)
                            
                            Text("Оплата заказа возможна двумя способами:")
                                .font(.callout)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Image(systemName: "banknote.fill")
                                    .foregroundColor(.green)
                                Text("Наличными")
                            }
                            .font(.callout)
                            
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .foregroundColor(.blue)
                                Text("Банковской картой")
                            }
                            .font(.callout)
                        }
                        .padding()
                        .background(Color("DarkModeElBg"))
                        .cornerRadius(12)
                        
                        Spacer(minLength: 50)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing], 8)
                    
                } else {
                    Text("Нет данных")
                        .padding()
                }
            }
            .background(Color("DarkModeBg"))
            .navigationTitle("Доставка")
            .navigationBarTitleDisplayMode(.large)
            .task {
                await deliveryData.fetchDelivery()
            }

        }

    }
}
