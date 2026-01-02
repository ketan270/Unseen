//
//  HearingLossView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI
import AVFoundation

struct HearingLossView: View {
    @StateObject private var audioSimulator = AudioSimulator()
    @State private var showInfo = false
    @State private var hearingLossLevel: Double = 0.0 // 0 = normal, 1 = severe
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Hearing Loss")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(AccessibilityCondition.hearingLoss.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Hearing level control
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Hearing Level")
                            .font(Theme.headline)
                        
                        Spacer()
                        
                        Text(hearingLevelText)
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.blue)
                        
                        Slider(value: $hearingLossLevel, in: 0...1)
                            .tint(.blue)
                            .onChange(of: hearingLossLevel) { _, newValue in
                                audioSimulator.setHearingLoss(level: newValue)
                            }
                        
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .contentCard()
                .padding(.horizontal)
                
                // Info card
                if hearingLossLevel > 0.3 {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text("Notice how sounds become muffled and harder to distinguish")
                            .font(Theme.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal)
                }
                
                // Audio demos
                VStack(spacing: Theme.paddingMedium) {
                    Text("Audio Scenarios")
                        .font(Theme.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    AudioScenarioCard(
                        title: "Notification Sound",
                        icon: "bell.fill",
                        description: "A typical phone notification",
                        color: .blue,
                        isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "notification"
                    ) {
                        audioSimulator.playSound("notification")
                    }
                    
                    AudioScenarioCard(
                        title: "Alarm",
                        icon: "alarm.fill",
                        description: "Morning alarm sound",
                        color: .orange,
                        isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "alarm"
                    ) {
                        audioSimulator.playSound("alarm")
                    }
                    
                    AudioScenarioCard(
                        title: "Voice Message",
                        icon: "waveform",
                        description: "Someone speaking",
                        color: .purple,
                        isPlaying: audioSimulator.isPlaying && audioSimulator.currentSound == "voice"
                    ) {
                        audioSimulator.playSound("voice")
                    }
                }
                .padding(.horizontal)
                
                // Caption demo
                CaptionDemoView()
                    .padding(.horizontal)
            }
            .padding(.bottom, Theme.paddingLarge)
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            HearingLossInfoSheet()
        }
    }
    
    private var hearingLevelText: String {
        switch hearingLossLevel {
        case 0..<0.2:
            return "Normal"
        case 0.2..<0.5:
            return "Mild Loss"
        case 0.5..<0.8:
            return "Moderate Loss"
        default:
            return "Severe Loss"
        }
    }
}

struct AudioScenarioCard: View {
    let title: String
    let icon: String
    let description: String
    let color: Color
    let isPlaying: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.paddingMedium) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: isPlaying ? "stop.fill" : icon)
                        .font(.title3)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isPlaying ? "speaker.wave.3.fill" : "play.fill")
                    .foregroundColor(color)
            }
            .padding()
            .contentCard()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HearingLossInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Hearing loss can range from mild to profound and affects how people perceive sounds, speech, and environmental audio cues.")
                        .font(Theme.body)
                    
                    Text(AccessibilityCondition.hearingLoss.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "checkmark.circle.fill", text: "Always provide captions for videos")
                        TipRow(icon: "checkmark.circle.fill", text: "Use visual indicators for audio alerts")
                        TipRow(icon: "checkmark.circle.fill", text: "Provide transcripts for audio content")
                        TipRow(icon: "checkmark.circle.fill", text: "Don't rely solely on sound for important info")
                    }
                }
                .padding()
            }
            .navigationTitle("About Hearing Loss")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HearingLossView()
    }
}
