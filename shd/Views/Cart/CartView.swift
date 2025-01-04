//
//  CartView.swift
//  shd
//
//  Created by Тигран Дарчинян on 28.12.2024.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartData: CartData
    @State var showBottomSheet = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    if cartData.items.isEmpty {
                        Image("empty-cart")
                            .padding(.top, 60)
                        Text("Вероятно, вы еще ничего не заказали.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.body)
                            .padding(.top, 20)
                        Text("Перейдите в меню для заказа.")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.body)
                    } else {
                        VStack {
                            VStack(alignment: .leading) {
                                ForEach(cartData.items, id: \.id) { item in
                                    CartItemRow(item: item, cartData: cartData)
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                if !cartData.items.isEmpty {
                    Button(action: {
                        showBottomSheet.toggle()
                    }) {
                        HStack{
                            Text("Оформить")
                            Spacer()
                            Text("\(cartData.totalCount)шт.")
                            Spacer()
                            Text("\(cartData.totalPrice) ₽")
                        }
                        .font(.callout).bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                }
                                .padding(.horizontal, 16)
                    .sheet(isPresented: $showBottomSheet) {
                        OrderView(cartData: cartData)
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            .background(Color("DarkModeBg").ignoresSafeArea())
            .navigationTitle("Корзина")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    CartView(cartData: CartData())
}
