//
//  AuthenticationView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var showSignUp = false
    
    var body: some View {
        ZStack {
            if showSignUp {
                SignUpView(showSignUp: $showSignUp)
                    .transition(.move(edge: .trailing))
            } else {
                LoginView(showSignUp: $showSignUp)
                    .transition(.move(edge: .leading))
            }
        }
        .animation(Theme.easeAnimation, value: showSignUp)
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationState())
}
