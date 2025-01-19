//
//  PreLoader.swift
//  shd
//
//  Created by Тигран Дарчинян on 05.01.2025.
//
import SwiftUI
import Lottie

struct PreLoader: UIViewRepresentable {
    var animationName: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 100),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // Получаем LottieAnimationView
        if let animationView = uiView.subviews.first as? LottieAnimationView {
            // Меняем анимацию, если имя изменилось
            animationView.animation = LottieAnimation.named(animationName)
            animationView.play()
        }
    }
}
