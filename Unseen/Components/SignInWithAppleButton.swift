//
//  SignInWithAppleButton.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: View {
    let action: (ASAuthorizationAppleIDCredential) -> Void
    @State private var isLoading = false
    
    var body: some View {
        SignInWithAppleButtonRepresentable(action: action)
            .frame(height: 50)
            .cornerRadius(Theme.buttonCornerRadius)
    }
}

// UIViewRepresentable wrapper for ASAuthorizationAppleIDButton
struct SignInWithAppleButtonRepresentable: UIViewRepresentable {
    let action: (ASAuthorizationAppleIDCredential) -> Void
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleTap), for: .touchUpInside)
        button.cornerRadius = 12
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        let action: (ASAuthorizationAppleIDCredential) -> Void
        
        init(action: @escaping (ASAuthorizationAppleIDCredential) -> Void) {
            self.action = action
        }
        
        @objc func handleTap() {
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                action(credential)
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("Apple Sign In failed: \(error.localizedDescription)")
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
                return UIWindow()
            }
            return window
        }
    }
}
