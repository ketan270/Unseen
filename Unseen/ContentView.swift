//
//  ContentView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var showWelcome = true
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
