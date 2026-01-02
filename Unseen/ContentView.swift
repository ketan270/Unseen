//
//  ContentView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authState: AuthenticationState
    @State private var showWelcome = true
    
    var body: some View {
        Group {
            if authState.isCheckingAuth {
                // Show loading screen while checking authentication
                LoadingView()
            } else if authState.isAuthenticated {
                // Main app flow (authenticated)
                NavigationStack {
                    ZStack {
                        if showWelcome {
                            WelcomeView(showWelcome: $showWelcome)
                                .transition(.opacity)
                        } else {
                            ConditionSelectorView(showWelcome: $showWelcome)
                                .transition(.opacity)
                        }
                    }
                    .animation(Theme.easeAnimation, value: showWelcome)
                }
            } else {
                // Authentication flow (not authenticated)
                AuthenticationView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationState())
}
