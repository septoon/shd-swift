//
//  Colors.swift
//  shd
//
//  Created by Тигран Дарчинян on 29.12.2024.
//

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct AppColors {
    static let transparent = Color.clear
    static let primary = Color(hex: "#1E90FF")
    static let main = Color(hex: "#007da0")
    static let secondary = Color(hex: "#6fd9e5")
    static let back = Color(hex: "#21A599")
    static let bgOrder = Color(hex: "#EFEFF4")
    static let bgInput = Color(hex: "#EBEBEE")
    
    static func darkModeText(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.white : Color.black
    }

    static func darkModeBg(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hex: "#131922") : Color(hex: "#f0eef6")
    }
    
    static func darkModeElBg(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hex: "#151517") : Color.white
    }
    
    static let darkModeIcon = Color(hex: "#737373")
    static let darkModeInput = Color(hex: "#E0E0E0")
    static let historyBtn = Color(hex: "#EAB68F")
    static let slideBg = Color(hex: "#f0f0f0")
    static let purple = Color(hex: "#3f3cbb")
    static let blue = Color(hex: "#316ff4")
    static let midnight = Color(hex: "#121063")
    static let metal = Color(hex: "#565584")
    static let tahiti = Color(hex: "#3ab7bf")
    static let bubblegum = Color(hex: "#ff77e9")
    static let bermuda = Color(hex: "#78dcca")
    static let gray = Color.gray
    static let lightGray = Color(hex: "#D3D3D3")
    static let darkGray = Color(hex: "#141616")
    static let red = Color.red
    static let orange = Color.orange
}
