//
//  AuthUser.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import Foundation

struct AuthUser: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let authProvider: AuthProvider
    let createdAt: Date
    
    enum AuthProvider: String, Codable {
        case email
        case apple
    }
}

// MARK: - API Response Models
struct AuthResponse: Codable {
    let user: AuthUser
    let token: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct SignUpRequest: Codable {
    let name: String
    let email: String
    let password: String
}

struct AppleSignInRequest: Codable {
    let identityToken: String
    let authorizationCode: String
    let fullName: PersonNameComponents?
    
    enum CodingKeys: String, CodingKey {
        case identityToken
        case authorizationCode
        case fullName
    }
}
