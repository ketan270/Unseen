//
//  LoadingView.swift
//  Unseen
//
//  Created by Ketan Sharma on 02/01/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            // Gradient background matching login/signup
            Theme.appGradient
                .ignoresSafeArea()
            
            VStack(spacing: Theme.paddingLarge) {
                // App logo/icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "eye.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(Theme.body)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    LoadingView()
}
