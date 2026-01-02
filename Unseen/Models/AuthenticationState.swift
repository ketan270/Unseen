//
//  AuthenticationState.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import Foundation
import Combine

@MainActor
class AuthenticationState: ObservableObject {
    @Published var currentUser: AuthUser?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var isCheckingAuth: Bool = true // Track initial auth check
    @Published var errorMessage: String?
    
    private let authService = AuthenticationService.shared
    private let keychainManager = KeychainManager.shared
    
    init() {
        // Check for existing session on app start
        checkAuthenticationStatus()
    }
    
    // MARK: - Authentication Status
    func checkAuthenticationStatus() {
        // Check if we have a stored token
        if let token = keychainManager.getToken() {
            // Validate token with backend
            Task {
                await validateSession(token: token)
                isCheckingAuth = false
            }
        } else {
            isCheckingAuth = false
        }
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            
            // Save token to keychain
            keychainManager.saveToken(response.token)
            
            // Update state
            currentUser = response.user
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.signUp(name: name, email: email, password: password)
            
            // Save token to keychain
            keychainManager.saveToken(response.token)
            
            // Update state
            currentUser = response.user
            isAuthenticated = true
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Logout
    func logout() {
        keychainManager.deleteToken()
        currentUser = nil
        isAuthenticated = false
    }
    
    // MARK: - Session Validation
    private func validateSession(token: String) async {
        do {
            let user = try await authService.validateSession(token: token)
            currentUser = user
            isAuthenticated = true
        } catch {
            // Token is invalid, clear it
            keychainManager.deleteToken()
            isAuthenticated = false
        }
    }
}
