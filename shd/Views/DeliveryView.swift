//
//  DeliveryView.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI

struct DeliveryView: View {
    @ObservedObject var deliveryData: DeliveryData
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("DarkModeBg")
                    .ignoresSafeArea()
                VStack {
                    // Если идёт загрузка
                    if deliveryData.isLoading {
                        ZStack {
                            Color("DarkModeBg")
                                .ignoresSafeArea()

                            PreLoader(animationName: "Preloader")
                                .frame(width: 100, height: 100)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                            
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
                        
                    } else if let d = deliveryData.delivery {
                        
                        List {
                            Section(header: Text("Правила")) {
                                if d.paidDelivery {
                                    HStack {
                                        Text("Если сумма заказа превышает \(d.minDeliveryAmount)р, доставка по городу бесплатная!")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack {
                                        Text("Если сумма заказа меньше \(d.minDeliveryAmount)р, стоимость доставки по городу – \(d.deliveryCost)р.")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                } else {
                                    HStack {
                                        Text("Минимальная сумма заказа для оформления доставки – \(d.minDeliveryAmount)р.")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack {
                                        Text("Стоимость доставки по городу – бесплатная!")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    HStack {
                                        Text("Если сумма заказа составляет менее \(d.minDeliveryAmount)р, можете оформить самовывоз.")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                }
                                HStack {
                                    Text("Режим работы доставки: \(d.deliveryStart):00 – \(d.deliveryEnd):00.")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                }
                                
                            }
                            
                            if d.promotion {
                                Section(header: Text("Акция")) {
                                    VStack(alignment: .leading) {
                                        Text("СКИДКА \(d.promotionCount)%")
                                            .font(.title)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.blue)
                                        Text("На доставку и самовывоз!")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                    }
                                    
                                }
                            }
                            
                            Section(header: Text("Инструкция по оформлению заказа")) {
                                
                                HStack {
                                    Text("Для осуществления заказа Вам необходимо:")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("""
                                         1. Оформить заказ на сайте: выбрать интересующие вас блюда в меню, \
                                         добавить их в корзину, заполнить контактные данные в диалоговом \
                                         окне и оформить заказ.
                                         """)
                                        .font(.callout)
                                }
                                
                                HStack {
                                    Text("""
                                         2. Или позвонить по номеру (укажите здесь контактный номер).
                                         После получения заявки, в течение 10 минут, наш менеджер свяжется \
                                         с вами для подтверждения заказа.
                                         """)
                                        .font(.callout)
                                }
                                
                                HStack {
                                    Text("Оплата заказа возможна двумя способами:")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                }
                                
                                
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
                        
                        }
                        .scrollContentBackground(.hidden)
                    } else {
                        ZStack {
                            Color("DarkModeBg")
                                .ignoresSafeArea()

                            PreLoader(animationName: "Preloader")
                                .frame(width: 100, height: 100)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                    }
                }
            }
            
            .navigationTitle("Доставка")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await deliveryData.fetchDelivery()
            }

        }

    }
}

#Preview {
    DeliveryView(deliveryData: DeliveryData())
}
