//
//  AuthenticationService.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import Foundation

enum AuthError: LocalizedError {
    case invalidCredentials
    case networkError
    case invalidResponse
    case serverError(String)
    case validationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network connection failed. Please check your internet."
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let message):
            return message
        case .validationError(let message):
            return message
        }
    }
}

class AuthenticationService {
    static let shared = AuthenticationService()
    
    // MARK: - Configuration
    // TODO: Replace with your Railway URL after deployment
    private let baseURL = "http://localhost:3000"
    
    // MARK: - Demo Mode
    // Set this to false when you deploy your backend
    var isDemoMode = true
    
    private init() {}
    
    // MARK: - Login
    func login(email: String, password: String) async throws -> AuthResponse {
        // Validate inputs
        guard isValidEmail(email) else {
            throw AuthError.validationError("Please enter a valid email address")
        }
        
        guard !password.isEmpty else {
            throw AuthError.validationError("Password cannot be empty")
        }
        
        // Use Firebase
        return try await FirebaseAuthService.shared.login(email: email, password: password)
    }
    
    // MARK: - Sign Up
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        // Validate inputs
        guard !name.isEmpty else {
            throw AuthError.validationError("Name cannot be empty")
        }
        
        guard isValidEmail(email) else {
            throw AuthError.validationError("Please enter a valid email address")
        }
        
        guard isValidPassword(password) else {
            throw AuthError.validationError("Password must be at least 8 characters with letters and numbers")
        }
        
        // Use Firebase
        return try await FirebaseAuthService.shared.signUp(name: name, email: email, password: password)
    }
    
    // MARK: - Validate Session
    func validateSession(token: String) async throws -> AuthUser {
        // Use Firebase
        return try await FirebaseAuthService.shared.validateSession(token: token)
    }
    
    // MARK: - Helper Methods
    private func performRequest<T: Codable, R: Codable>(endpoint: String, method: String, body: T) async throws -> R {
        guard let url = URL(string: endpoint) else {
            throw AuthError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            // Handle different status codes
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(R.self, from: data)
            case 401:
                throw AuthError.invalidCredentials
            case 400...499:
                // Try to parse error message from server
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = errorResponse["message"] {
                    throw AuthError.serverError(message)
                }
                throw AuthError.invalidCredentials
            default:
                throw AuthError.serverError("Server error occurred")
            }
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.networkError
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // At least 8 characters, contains letters and numbers
        return password.count >= 8 &&
               password.rangeOfCharacter(from: .letters) != nil &&
               password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    // MARK: - Demo Mode Helper
    private func createMockAuthResponse(email: String, name: String, provider: AuthUser.AuthProvider) -> AuthResponse {
        let user = AuthUser(
            id: UUID().uuidString,
            email: email,
            name: name,
            authProvider: provider,
            createdAt: Date()
        )
        return AuthResponse(user: user, token: "demo-token-\(UUID().uuidString)")
    }
}
