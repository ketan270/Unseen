//
//  AuthTextField.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct AuthTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .none
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textContentType(.password)
                    .autocapitalization(.none)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textContentType(keyboardType == .emailAddress ? .emailAddress : .none)
                    .autocapitalization(autocapitalization == .words ? .words : .none)
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.buttonCornerRadius)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(Theme.buttonCornerRadius)
    }
}

#Preview {
    VStack(spacing: 16) {
        AuthTextField(icon: "envelope.fill", placeholder: "Email", text: .constant(""), keyboardType: .emailAddress)
        AuthTextField(icon: "lock.fill", placeholder: "Password", text: .constant(""), isSecure: true)
        AuthTextField(icon: "person.fill", placeholder: "Name", text: .constant(""), autocapitalization: .words)
    }
    .padding()
    .background(Theme.appGradient)
}
