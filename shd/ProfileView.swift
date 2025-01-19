//
//  ProfileView.swift
//  shd
//
//  Created by Тигран Дарчинян on 19.01.2025.
//

import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Spacer()
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: configure,
                        onCompletion: handle
                    )
                    .frame(width: 200, height: 45)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color("DarkModeBg").edgesIgnoringSafeArea(.all))
        }
    }
    
    
    private func configure(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    private func handle(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userID = appleIDCredential.user
                print("User ID: \(userID)")
            }
        case .failure(let error):
            print("Authorization failed: \(error.localizedDescription)")
        }
    }
}
