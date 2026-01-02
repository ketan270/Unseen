//
//  LimitedMobilityView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct LimitedMobilityView: View {
    @State private var difficultyLevel: Double = 0.0 // 0 = normal, 1 = severe
    @State private var showInfo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Limited Mobility")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(AccessibilityCondition.limitedMobility.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Difficulty control
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    HStack {
                        Text("Motor Difficulty")
                            .font(Theme.headline)
                        
                        Spacer()
                        
                        Text(difficultyText)
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "hand.raised.fill")
                            .foregroundColor(.green)
                        
                        Slider(value: $difficultyLevel, in: 0...1)
                            .tint(.green)
                        
                        Image(systemName: "hand.raised.slash.fill")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .contentCard()
                .padding(.horizontal)
                
                // Info card
                if difficultyLevel > 0.3 {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                        Text("Notice how interactions become harder and less precise")
                            .font(Theme.body)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal)
                }
                
                // Interactive tasks
                InteractionTasksView(difficultyLevel: difficultyLevel)
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
            LimitedMobilityInfoSheet()
        }
    }
    
    private var difficultyText: String {
        switch difficultyLevel {
        case 0..<0.2:
            return "Normal"
        case 0.2..<0.5:
            return "Mild Difficulty"
        case 0.5..<0.8:
            return "Moderate Difficulty"
        default:
            return "Severe Difficulty"
        }
    }
}

struct LimitedMobilityInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Limited mobility can affect fine motor control, making precise interactions challenging. Conditions include arthritis, tremors, paralysis, and many others.")
                        .font(Theme.body)
                    
                    Text(AccessibilityCondition.limitedMobility.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "checkmark.circle.fill", text: "Make touch targets at least 44x44 points")
                        TipRow(icon: "checkmark.circle.fill", text: "Provide adequate spacing between interactive elements")
                        TipRow(icon: "checkmark.circle.fill", text: "Support alternative input methods (voice, switch control)")
                        TipRow(icon: "checkmark.circle.fill", text: "Avoid time-sensitive interactions")
                        TipRow(icon: "checkmark.circle.fill", text: "Allow undo for destructive actions")
                    }
                }
                .padding()
            }
            .navigationTitle("About Limited Mobility")
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
        LimitedMobilityView()
    }
}
