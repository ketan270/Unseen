//
//  ColorBlindnessView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct ColorBlindnessView: View {
    @State private var selectedType: ColorBlindnessType = .normal
    @State private var showInfo = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.paddingLarge) {
                // Header
                VStack(spacing: Theme.paddingSmall) {
                    Text("Color Blindness")
                        .font(Theme.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(AccessibilityCondition.colorBlindness.statistics)
                        .font(Theme.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                
                // Type selector
                VStack(alignment: .leading, spacing: Theme.paddingMedium) {
                    Text("Select Vision Type")
                        .font(Theme.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.paddingMedium) {
                            ForEach(ColorBlindnessType.allCases) { type in
                                TypeChip(
                                    type: type,
                                    isSelected: selectedType == type,
                                    action: {
                                        withAnimation(Theme.springAnimation) {
                                            selectedType = type
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Current type info
                if selectedType != .normal {
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.blue)
                            Text(selectedType.description)
                                .font(Theme.body)
                                .fontWeight(.medium)
                        }
                        
                        Text("Affects \(selectedType.prevalence) of the population")
                            .font(Theme.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(Theme.buttonCornerRadius)
                    .padding(.horizontal)
                }
                
                // Demo content
                ColorDemoView(filterType: selectedType)
                    .padding(.horizontal)
            }
            .padding(.bottom, Theme.paddingLarge)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showInfo = true }) {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .sheet(isPresented: $showInfo) {
            ColorBlindnessInfoSheet()
        }
    }
}

struct TypeChip: View {
    let type: ColorBlindnessType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(type.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(isSelected ? .white : .primary)
                .lineLimit(1)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    isSelected ?
                        AnyView(Theme.primaryGradient) :
                        AnyView(Color(.tertiarySystemGroupedBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.buttonCornerRadius)
                        .stroke(
                            isSelected ? Color.clear : Color.white.opacity(0.15),
                            lineWidth: 1
                        )
                )
                .cornerRadius(Theme.buttonCornerRadius)
                .shadow(
                    color: Color.black.opacity(isSelected ? 0.3 : 0.2),
                    radius: isSelected ? 8 : 5,
                    x: 0,
                    y: isSelected ? 4 : 2
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorBlindnessInfoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.paddingLarge) {
                    Text("Color blindness affects how people perceive colors. It's usually genetic and affects more men than women.")
                        .font(Theme.body)
                    
                    Text(AccessibilityCondition.colorBlindness.impact)
                        .font(Theme.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("Design Tips")
                        .font(Theme.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: Theme.paddingSmall) {
                        TipRow(icon: "checkmark.circle.fill", text: "Use patterns or labels in addition to color")
                        TipRow(icon: "checkmark.circle.fill", text: "Ensure sufficient contrast ratios")
                        TipRow(icon: "checkmark.circle.fill", text: "Test designs with color blindness simulators")
                        TipRow(icon: "checkmark.circle.fill", text: "Avoid red-green combinations for critical info")
                    }
                }
                .padding()
            }
            .navigationTitle("About Color Blindness")
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
        ColorBlindnessView()
    }
}
