//
//  ConditionSelectorView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ConditionSelectorView: View {
    @Binding var showWelcome: Bool
    @State private var selectedCondition: AccessibilityCondition?
    @State private var showInfo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Choose an Experience")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Discover how others experience the world")
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, Theme.paddingLarge)
                
                // Experience cards
                ForEach(AccessibilityCondition.allCases) { condition in
                    NavigationLink(destination: destinationView(for: condition)) {
                        ExperienceCard(condition: condition) {
                            selectedCondition = condition
                        }
                    }
                }
            }
            .padding(.horizontal, Theme.paddingLarge)
            .padding(.bottom, Theme.paddingLarge)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    withAnimation(Theme.springAnimation) {
                        showWelcome = true
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            InfoSheetView()
        }
    }
    
    @ViewBuilder
    private func destinationView(for condition: AccessibilityCondition) -> some View {
        switch condition {
        case .colorBlindness:
            ColorBlindnessView()
        case .hearingLoss:
            HearingLossView()
        case .limitedMobility:
            LimitedMobilityView()
        }
    }
}

#Preview {
    NavigationStack {
        ConditionSelectorView(showWelcome: .constant(false))
    }
}

