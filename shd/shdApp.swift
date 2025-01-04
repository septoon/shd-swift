//
//  shdApp.swift
//  shd
//
//  Created by Тигран Дарчинян on 27.12.2024.
//

import SwiftUI
import SwiftData

@main
struct Shd: App {
    @State private var showSplashScreen = true
    
    var body: some Scene {
        WindowGroup {
            if showSplashScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            showSplashScreen = false
                        }
                    }
            } else {
                MainTabView()
            }
        }
    }
}
