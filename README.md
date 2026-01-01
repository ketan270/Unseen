# Unseen - Experience the World with Disabilities

An immersive SwiftUI app for the Apple Swift Student Challenge that simulates how people with disabilities experience digital interfaces and the world around them.

## 🎯 Purpose

Unseen builds empathy and understanding by letting users experience three types of disabilities:
- **Color Blindness** - See how color vision deficiencies affect daily interactions
- **Hearing Loss** - Understand challenges of navigating a world designed for hearing
- **Limited Mobility** - Feel the difficulty of precise motor control

## ✨ Features

### Color Blindness Simulation
- Multiple types: Protanopia, Deuteranopia, Tritanopia, Achromatopsia
- Interactive demonstrations with traffic lights, UI buttons, and charts
- Real-time filter switching
- Educational information about each type

### Hearing Loss Simulation
- Adjustable hearing loss levels (mild to severe)
- Audio frequency filtering and muffling
- Interactive audio scenarios (notifications, alarms, voice)
- Caption demonstration showing importance of visual alternatives

### Limited Mobility Simulation
- Adjustable motor difficulty levels
- Tremor and precision reduction simulation
- Interactive tasks: button tapping, dragging, precise selection
- Real-time feedback on interaction challenges

## 🎨 Design

Built with native SwiftUI and Apple's design language:
- Clean, minimal interface with SF Symbols
- Smooth animations and transitions
- Haptic feedback for enhanced interaction
- Dynamic Type support
- VoiceOver compatible (accessible app about accessibility!)

## 🏗️ Architecture

```
Unseen/
├── Models/
│   ├── AccessibilityCondition.swift    # Main condition enum
│   └── ColorBlindnessType.swift        # Color blindness types
├── Views/
│   ├── WelcomeView.swift               # Onboarding
│   ├── ConditionSelectorView.swift     # Main selector
│   ├── ColorBlindness/
│   │   ├── ColorBlindnessView.swift
│   │   └── ColorDemoView.swift
│   ├── HearingLoss/
│   │   ├── HearingLossView.swift
│   │   └── CaptionDemoView.swift
│   └── LimitedMobility/
│       ├── LimitedMobilityView.swift
│       └── InteractionTasksView.swift
├── Components/
│   ├── ExperienceCard.swift            # Reusable card
│   └── InfoSheetView.swift             # Info overlay
└── Utilities/
    ├── Theme.swift                     # Design system
    ├── ColorBlindnessFilter.swift      # Visual filters
    └── AudioSimulator.swift            # Audio processing
```

## 🚀 Getting Started

1. Open `Unseen.xcodeproj` in Xcode
2. Select iPhone simulator (iPhone 15 Pro recommended)
3. Build and run (⌘R)

## 📱 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 🎓 Educational Impact

This app helps developers, designers, and users:
- Understand accessibility challenges firsthand
- Learn design best practices for inclusive apps
- Build empathy for users with disabilities
- Recognize the importance of accessible design

## 📊 Statistics

- ~8% of men have color vision deficiency
- 1.5+ billion people worldwide experience hearing loss
- Millions affected by conditions limiting motor control

## 🏆 Apple Swift Student Challenge

This app demonstrates:
- ✅ Native SwiftUI implementation
- ✅ Apple design language and HIG compliance
- ✅ Accessibility focus (Apple's core value)
- ✅ Educational and empathy-building
- ✅ Fully functional interactive experiences
- ✅ Clean, maintainable code architecture

## 📝 License

Created for the Apple Swift Student Challenge 2026 by Ketan Sharma.

---

**Built with ❤️ and empathy**
