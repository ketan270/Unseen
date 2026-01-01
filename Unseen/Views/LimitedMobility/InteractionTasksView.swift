//
//  InteractionTasksView.swift
//  Unseen
//
//  Created by Ketan Sharma on 01/01/26.
//

import SwiftUI

struct InteractionTasksView: View {
    let difficultyLevel: Double
    
    var body: some View {
        VStack(spacing: Theme.paddingLarge) {
            Text("Try These Tasks")
                .font(Theme.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Small button tapping
            SmallButtonTask(difficultyLevel: difficultyLevel)
            
            // Drag task
            DragTask(difficultyLevel: difficultyLevel)
            
            // Precise tap task
            PreciseTapTask(difficultyLevel: difficultyLevel)
        }
    }
}

struct SmallButtonTask: View {
    let difficultyLevel: Double
    @State private var tappedButtons: Set<Int> = []
    @State private var attempts = 0
    
    let buttonSizes: [CGFloat] = [60, 44, 32, 24]
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Text("Tap All Buttons")
                    .font(Theme.headline)
                
                Spacer()
                
                Text("\(tappedButtons.count)/\(buttonSizes.count)")
                    .font(Theme.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 20) {
                ForEach(0..<buttonSizes.count, id: \.self) { index in
                    Button(action: {
                        handleTap(index: index)
                    }) {
                        ZStack {
                            Circle()
                                .fill(tappedButtons.contains(index) ? Color.green : Color.blue)
                                .frame(width: buttonSizes[index], height: buttonSizes[index])
                            
                            if tappedButtons.contains(index) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: buttonSizes[index] * 0.4))
                            }
                        }
                    }
                    .motorDifficulty(level: difficultyLevel)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            
            if tappedButtons.count == buttonSizes.count {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Task completed! Attempts: \(attempts)")
                        .font(Theme.caption)
                }
            }
        }
        .padding()
        .contentCard()
    }
    
    private func handleTap(index: Int) {
        attempts += 1
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        tappedButtons.insert(index)
    }
}

struct DragTask: View {
    let difficultyLevel: Double
    @State private var circlePosition = CGPoint(x: 50, y: 50)
    @State private var isInTarget = false
    @State private var taskCompleted = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Text("Drag to Target")
                    .font(Theme.headline)
                
                Spacer()
                
                if taskCompleted {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Success!")
                            .font(Theme.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack {
                    // Target area
                    Circle()
                        .strokeBorder(isInTarget ? Color.green : Color.blue.opacity(0.3), lineWidth: 3)
                        .background(Circle().fill(Color.blue.opacity(0.1)))
                        .frame(width: 80, height: 80)
                        .position(x: geometry.size.width - 50, y: 50)
                    
                    // Draggable circle
                    Circle()
                        .fill(isInTarget ? Color.green : Color.orange)
                        .frame(width: 40, height: 40)
                        .position(circlePosition)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    var newPosition = value.location
                                    
                                    // Apply difficulty - add random offset
                                    if difficultyLevel > 0 {
                                        let offset = difficultyLevel * 20
                                        newPosition.x += CGFloat.random(in: -offset...offset)
                                        newPosition.y += CGFloat.random(in: -offset...offset)
                                    }
                                    
                                    circlePosition = newPosition
                                    
                                    // Check if in target
                                    let targetCenter = CGPoint(x: geometry.size.width - 50, y: 50)
                                    let distance = sqrt(pow(circlePosition.x - targetCenter.x, 2) + pow(circlePosition.y - targetCenter.y, 2))
                                    isInTarget = distance < 40
                                }
                                .onEnded { _ in
                                    if isInTarget && !taskCompleted {
                                        taskCompleted = true
                                        let impact = UINotificationFeedbackGenerator()
                                        impact.notificationOccurred(.success)
                                    }
                                }
                        )
                }
            }
            .frame(height: 100)
        }
        .padding()
        .contentCard()
    }
}

struct PreciseTapTask: View {
    let difficultyLevel: Double
    @State private var score = 0
    @State private var misses = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.paddingMedium) {
            HStack {
                Text("Tap Only Green")
                    .font(Theme.headline)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Score: \(score)")
                        .font(Theme.caption)
                        .foregroundColor(.green)
                    Text("Misses: \(misses)")
                        .font(Theme.caption)
                        .foregroundColor(.red)
                }
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                ForEach(0..<12, id: \.self) { index in
                    let isGreen = index % 3 == 0
                    
                    Button(action: {
                        handleTap(isCorrect: isGreen)
                    }) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isGreen ? Color.green : Color.red)
                            .frame(height: 60)
                    }
                    .motorDifficulty(level: difficultyLevel)
                }
            }
        }
        .padding()
        .contentCard()
    }
    
    private func handleTap(isCorrect: Bool) {
        if isCorrect {
            score += 1
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        } else {
            misses += 1
            let impact = UINotificationFeedbackGenerator()
            impact.notificationOccurred(.error)
        }
    }
}

// Motor difficulty modifier
struct MotorDifficultyModifier: ViewModifier {
    let level: Double
    @State private var offset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .offset(offset)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if level > 0 {
                            // Add tremor effect
                            let shake = level * 10
                            offset = CGSize(
                                width: CGFloat.random(in: -shake...shake),
                                height: CGFloat.random(in: -shake...shake)
                            )
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3)) {
                            offset = .zero
                        }
                    }
            )
    }
}

extension View {
    func motorDifficulty(level: Double) -> some View {
        self.modifier(MotorDifficultyModifier(level: level))
    }
}

#Preview {
    ScrollView {
        InteractionTasksView(difficultyLevel: 0.5)
            .padding()
    }
}
