//
//  FirebaseAuthService.swift
//  Unseen
//
//  Created by Ketan Sharma on 02/01/26.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    
    private init() {}
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        // Create user with Firebase
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // Update display name
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        // Get ID token
        let token = try await authResult.user.getIDToken()
        
        // Create user object
        let user = AuthUser(
            id: authResult.user.uid,
            email: email,
            name: name,
            authProvider: .email,
            createdAt: authResult.user.metadata.creationDate ?? Date()
        )
        
        return AuthResponse(user: user, token: token)
    }
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> AuthResponse {
        // Sign in with Firebase
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        // Get ID token
        let token = try await authResult.user.getIDToken()
        
        // Create user object
        let user = AuthUser(
            id: authResult.user.uid,
            email: email,
            name: authResult.user.displayName ?? "User",
            authProvider: .email,
            createdAt: authResult.user.metadata.creationDate ?? Date()
        )
        
        return AuthResponse(user: user, token: token)
    }
    
    // MARK: - Validate Session
    func validateSession(token: String) async throws -> AuthUser {
        // Check if user is signed in
        guard let currentUser = Auth.auth().currentUser else {
            throw NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user signed in"])
        }
        
        // Refresh token to ensure it's valid
        try await currentUser.reload()
        
        // Create user object
        let user = AuthUser(
            id: currentUser.uid,
            email: currentUser.email ?? "",
            name: currentUser.displayName ?? "User",
            authProvider: .email,
            createdAt: currentUser.metadata.creationDate ?? Date()
        )
        
        return user
    }
    
    // MARK: - Logout
    func logout() throws {
        try Auth.auth().signOut()
    }
}
