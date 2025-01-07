//
//  PrivatPolicy.swift
//  shd
//
//  Created by Тигран Дарчинян on 07.01.2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Binding var showWebView: Bool
    var baseURL: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("Оформляя заказ вы соглашаетесь с нашей ")
                .font(.footnote)
            Text("политикой конфиденциальности.")
                .font(.footnote)
                .foregroundColor(.blue)
                .underline()
                .onTapGesture {
                    showWebView = true
                }
        }
        .frame(height: 10)
        .padding(.top, 10)
        .opacity(0.6)
        .sheet(isPresented: $showWebView) {
            WebView(url: URL(string: "\(baseURL)/policy")!)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
