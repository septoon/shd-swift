//
//  LaunchScreenView.swift
//  shd
//
//  Created by Тигран Дарчинян on 29.12.2024.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()
            SplashView()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}
