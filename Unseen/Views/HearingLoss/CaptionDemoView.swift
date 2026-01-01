//
//  CaptionDemoView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct CaptionDemoView: View {
    @State private var showCaptions = true
    @State private var isVideoPlaying = false
    
    let videoScript = [
        "Welcome to our accessibility tutorial.",
        "Today we'll learn about inclusive design.",
        "Making apps accessible benefits everyone."
    ]
    
    @State private var currentCaptionIndex = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            Text("Video with Captions")
                .font(Theme.headline)
            
            VStack(spacing: 0) {
                // Mock video player
                ZStack {
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack {
                        Image(systemName: "video.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                        
                        if isVideoPlaying {
                            HStack(spacing: 4) {
                                ForEach(0..<3) { i in
                                    Capsule()
                                        .fill(Color.white.opacity(0.8))
                                        .frame(width: 4, height: 20)
                                        .animation(
                                            Animation.easeInOut(duration: 0.5)
                                                .repeatForever()
                                                .delay(Double(i) * 0.2),
                                            value: isVideoPlaying
                                        )
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                    // Captions overlay
                    if showCaptions && isVideoPlaying {
                        VStack {
                            Spacer()
                            
                            Text(videoScript[currentCaptionIndex])
                                .font(Theme.body)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                    
                    // Play button
                    if !isVideoPlaying {
                        Button(action: togglePlayback) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.9))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "play.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .frame(height: 200)
                
                // Controls
                HStack {
                    Toggle(isOn: $showCaptions) {
                        HStack {
                            Image(systemName: showCaptions ? "captions.bubble.fill" : "captions.bubble")
                            Text("Captions")
                                .font(Theme.body)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    Spacer()
                    
                    if isVideoPlaying {
                        Button(action: togglePlayback) {
                            HStack {
                                Image(systemName: "stop.fill")
                                Text("Stop")
                            }
                            .font(Theme.caption)
                            .foregroundColor(.red)
                        }
                    }
                }
                .padding()
                .background(Color(.tertiarySystemGroupedBackground))
            }
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            
            // Info
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
                Text("Try watching with captions off to experience the challenge")
                    .font(Theme.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
        }
    }
    
    private func togglePlayback() {
        isVideoPlaying.toggle()
        
        if isVideoPlaying {
            currentCaptionIndex = 0
            startCaptionTimer()
        } else {
            stopCaptionTimer()
        }
    }
    
    private func startCaptionTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            withAnimation {
                currentCaptionIndex = (currentCaptionIndex + 1) % videoScript.count
            }
            
            // Stop after all captions shown
            if currentCaptionIndex == 0 {
                togglePlayback()
            }
        }
    }
    
    private func stopCaptionTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    CaptionDemoView()
        .padding()
}
