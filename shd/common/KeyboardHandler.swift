//
//  KeyboardHandler.swift
//  shd
//
//  Created by Тигран Дарчинян on 06.01.2025.
//

import SwiftUI
import Combine

struct KeyboardHandler: ViewModifier {
    @Binding var keyboardOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardOffset)
            .onAppear {
                addKeyboardObservers()
            }
            .onDisappear {
                removeKeyboardObservers()
            }
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardOffset = keyboardFrame.height
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardOffset = 0
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// Расширение для удобного вызова
extension View {
    func handleKeyboard(withOffset offset: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardHandler(keyboardOffset: offset))
    }
}
