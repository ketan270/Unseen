//
//  SignOutButton.swift
//  Unseen
//
//  Created by Ketan Sharma on 02/01/26.
//

import SwiftUI

struct SignOutButton: View {
    @EnvironmentObject var authState: AuthenticationState
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            showingAlert = true
        }) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundColor(.primary)
        }
        .alert("Sign Out", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authState.logout()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

#Preview {
    SignOutButton()
        .environmentObject(AuthenticationState())
}
