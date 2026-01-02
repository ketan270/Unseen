//
//  SignUpView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @EnvironmentObject var authState: AuthenticationState
    @Binding var showSignUp: Bool
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email, password, confirmPassword
    }
    
    var passwordsMatch: Bool {
        password == confirmPassword && !confirmPassword.isEmpty
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            Theme.appGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    
                    // Logo
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "eye.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, Theme.paddingLarge)
                    
                    // Title
                    VStack(spacing: Theme.paddingSmall) {
                        Text("Create Account")
                            .font(Theme.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Join us to explore accessibility")
                            .font(Theme.body)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, Theme.paddingXLarge)
                    
                    // White card with form
                    VStack(spacing: Theme.paddingLarge) {
                        // Name field
                        AuthTextField(
                            icon: "person.fill",
                            placeholder: "Full Name",
                            text: $name,
                            autocapitalization: .words
                        )
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }
                        
                        // Email field
                        AuthTextField(
                            icon: "envelope.fill",
                            placeholder: "Email",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                        
                        // Password field
                        AuthTextField(
                            icon: "lock.fill",
                            placeholder: "Password",
                            text: $password,
                            isSecure: true
                        )
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .confirmPassword }
                        
                        // Confirm password field
                        AuthTextField(
                            icon: "lock.fill",
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            isSecure: true
                        )
                        .focused($focusedField, equals: .confirmPassword)
                        .submitLabel(.go)
                        .onSubmit { handleSignUp() }
                        
                        // Password match indicator
                        if !confirmPassword.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: passwordsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(passwordsMatch ? .green : .red)
                                Text(passwordsMatch ? "Passwords match" : "Passwords don't match")
                                    .font(Theme.caption)
                                    .foregroundColor(passwordsMatch ? .green : .red)
                                Spacer()
                            }
                        }
                        
                        // Error message
                        if let error = authState.errorMessage {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(error)
                                    .font(Theme.caption)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(Theme.buttonCornerRadius)
                        }
                        
                        // Sign up button
                        Button(action: handleSignUp) {
                            if authState.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            } else {
                                Text("Create Account")
                                    .font(Theme.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                        }
                        .background(Theme.primaryGradient)
                        .cornerRadius(Theme.buttonCornerRadius)
                        .disabled(authState.isLoading || !isFormValid)
                        .opacity((authState.isLoading || !isFormValid) ? 0.6 : 1.0)
                        
                        // Divider
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(height: 1)
                            Text("or")
                                .font(Theme.caption)
                                .foregroundColor(.secondary)
                            Rectangle()
                                .fill(Color.secondary.opacity(0.3))
                                .frame(height: 1)
                        }
                        
                        // Sign up with Apple
                        SignInWithAppleButton { credential in
                            handleAppleSignIn(credential)
                        }
                    }
                    .padding(Theme.paddingLarge)
                    .background(Theme.cardOnGradientBackground)
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(
                        color: Theme.cardOnGradientShadow.color,
                        radius: Theme.cardOnGradientShadow.radius,
                        x: Theme.cardOnGradientShadow.x,
                        y: Theme.cardOnGradientShadow.y
                    )
                    .padding(.horizontal, Theme.paddingLarge)
                    
                    // Login link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(Theme.body)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Button("Sign In") {
                            showSignUp = false
                        }
                        .font(Theme.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    }
                    .padding(.top, Theme.paddingLarge)
                    
                    Spacer()
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty && passwordsMatch
    }
    
    private func handleSignUp() {
        guard passwordsMatch else { return }
        
        Task {
            await authState.signUp(name: name, email: email, password: password)
        }
    }
    
    private func handleAppleSignIn(_ credential: ASAuthorizationAppleIDCredential) {
        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8),
              let authCode = credential.authorizationCode,
              let authCodeString = String(data: authCode, encoding: .utf8) else {
            return
        }
        
        Task {
            await authState.signInWithApple(
                identityToken: tokenString,
                authorizationCode: authCodeString,
                fullName: credential.fullName
            )
        }
    }
}

#Preview {
    SignUpView(showSignUp: .constant(true))
        .environmentObject(AuthenticationState())
}
