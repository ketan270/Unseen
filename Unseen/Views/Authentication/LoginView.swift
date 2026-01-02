//
//  LoginView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authState: AuthenticationState
    @Binding var showSignUp: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            Theme.appGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
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
                        Text("Welcome Back")
                            .font(Theme.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Sign in to continue")
                            .font(Theme.body)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, Theme.paddingXLarge)
                    
                    // White card with form
                    VStack(spacing: Theme.paddingLarge) {
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
                        .submitLabel(.go)
                        .onSubmit { handleLogin() }
                        
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
                        
                        // Login button
                        Button(action: handleLogin) {
                            if authState.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            } else {
                                Text("Sign In")
                                    .font(Theme.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                        }
                        .background(Theme.primaryGradient)
                        .cornerRadius(Theme.buttonCornerRadius)
                        .disabled(authState.isLoading || email.isEmpty || password.isEmpty)
                        .opacity((authState.isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(Theme.paddingLarge)
                    .background(colorScheme == .dark ? Color(.systemGray6).opacity(0.95) : Color.white.opacity(0.95))
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(
                        color: Theme.cardOnGradientShadow.color,
                        radius: Theme.cardOnGradientShadow.radius,
                        x: Theme.cardOnGradientShadow.x,
                        y: Theme.cardOnGradientShadow.y
                    )
                    .padding(.horizontal, Theme.paddingLarge)
                    
                    // Sign up link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .font(Theme.body)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Button("Sign Up") {
                            showSignUp = true
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
    
    private func handleLogin() {
        Task {
            await authState.login(email: email, password: password)
        }
    }
}

#Preview {
    LoginView(showSignUp: .constant(false))
        .environmentObject(AuthenticationState())
}
