# Setup Instructions for Xcode

Since we created new files outside of Xcode, you'll need to add them to your Xcode project:

## Quick Setup

1. **Open Xcode** - The project should already be open
2. **Add all new files to the project:**

### Method 1: Drag and Drop (Easiest)
1. In Finder, navigate to `/Users/ketansharma/Desktop/Unseen/Unseen/`
2. Drag these folders into Xcode's Project Navigator:
   - `Models/`
   - `Views/`
   - `Components/`
   - `Utilities/`
3. When prompted, ensure:
   - ✅ "Copy items if needed" is UNCHECKED (files are already in place)
   - ✅ "Create groups" is selected
   - ✅ Target "Unseen" is checked

### Method 2: Add Files (Alternative)
1. Right-click on "Unseen" folder in Project Navigator
2. Select "Add Files to Unseen..."
3. Navigate to each folder and add:
   - `Models/AccessibilityCondition.swift`
   - `Models/ColorBlindnessType.swift`
   - `Utilities/Theme.swift`
   - `Utilities/ColorBlindnessFilter.swift`
   - `Utilities/AudioSimulator.swift`
   - `Views/WelcomeView.swift`
   - `Views/ConditionSelectorView.swift`
   - `Views/ColorBlindness/ColorBlindnessView.swift`
   - `Views/ColorBlindness/ColorDemoView.swift`
   - `Views/HearingLoss/HearingLossView.swift`
   - `Views/HearingLoss/CaptionDemoView.swift`
   - `Views/LimitedMobility/LimitedMobilityView.swift`
   - `Views/LimitedMobility/InteractionTasksView.swift`
   - `Components/ExperienceCard.swift`
   - `Components/InfoSheetView.swift`

## Build and Run

1. Select iPhone 15 Pro simulator (or any iPhone simulator)
2. Press ⌘R or click the Play button
3. The app should build and launch!

## Expected Project Structure in Xcode

```
Unseen
├── UnseenApp.swift
├── ContentView.swift
├── Models
│   ├── AccessibilityCondition.swift
│   └── ColorBlindnessType.swift
├── Views
│   ├── WelcomeView.swift
│   ├── ConditionSelectorView.swift
│   ├── ColorBlindness
│   │   ├── ColorBlindnessView.swift
│   │   └── ColorDemoView.swift
│   ├── HearingLoss
│   │   ├── HearingLossView.swift
│   │   └── CaptionDemoView.swift
│   └── LimitedMobility
│       ├── LimitedMobilityView.swift
│       └── InteractionTasksView.swift
├── Components
│   ├── ExperienceCard.swift
│   └── InfoSheetView.swift
├── Utilities
│   ├── Theme.swift
│   ├── ColorBlindnessFilter.swift
│   └── AudioSimulator.swift
└── Assets.xcassets
```

## Troubleshooting

### If you get build errors:
1. Clean build folder: Product → Clean Build Folder (⇧⌘K)
2. Restart Xcode
3. Make sure all files are added to the Unseen target

### If files don't appear:
1. Make sure you're looking in the Project Navigator (⌘1)
2. Check that files are in the correct folders on disk
3. Try the "Add Files" method instead of drag-and-drop

## Testing the App

Once running, you should see:
1. **Welcome Screen** - Beautiful animated onboarding
2. **Condition Selector** - Three colorful cards
3. **Each Experience** - Fully interactive simulations

Tap through each experience and adjust the sliders to see the effects!
