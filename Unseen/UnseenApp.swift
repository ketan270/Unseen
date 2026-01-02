//
//  UnseenApp.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

@main
struct UnseenApp: App {
    @StateObject private var authState = AuthenticationState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)
        }
    }
}
