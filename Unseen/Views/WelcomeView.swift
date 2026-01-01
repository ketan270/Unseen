//
//  WelcomeView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @State private var animateContent = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: Theme.paddingLarge) {
                Spacer()
                
                // App icon
                ZStack {
                    Circle()
                        .fill(Theme.primaryGradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "eye.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .scaleEffect(animateContent ? 1 : 0.5)
                .opacity(animateContent ? 1 : 0)
                
                // Title
                Text("Unseen")
                    .font(Theme.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1 : 0)
                
                // Tagline
                Text("Experience the World with Disabilities")
                    .font(Theme.title2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.paddingLarge)
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1 : 0)
                
                Spacer()
                
                // Description
                VStack(spacing: Theme.paddingMedium) {
                    FeatureRow(icon: "eye.fill", text: "See through color blindness", color: .purple)
                    FeatureRow(icon: "ear.fill", text: "Hear with hearing loss", color: .orange)
                    FeatureRow(icon: "hand.raised.fill", text: "Navigate with limited mobility", color: .green)
                }
                .padding(.horizontal, Theme.paddingLarge)
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1 : 0)
                
                Spacer()
                
                // Begin button
                Button(action: {
                    withAnimation(Theme.springAnimation) {
                        showWelcome = false
                    }
                }) {
                    HStack {
                        Text("Begin Experience")
                        Image(systemName: "arrow.right")
                    }
                    .primaryButtonStyle()
                }
                .padding(.horizontal, Theme.paddingLarge)
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1 : 0)
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(Theme.springAnimation.delay(0.2)) {
                animateContent = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.paddingMedium) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(text)
                .font(Theme.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(Theme.buttonCornerRadius)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    WelcomeView(showWelcome: .constant(true))
}
