# GoMaster - Professional Go Game for iOS 26

<div align="center">

![GoMaster Logo](Assets/logo.png)

**The Ancient Art of Go, Reimagined for iOS 26**

[![iOS](https://img.shields.io/badge/iOS-26.0+-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org/)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()

</div>

---

## 🎯 Overview

GoMaster is a premium Go (Weiqi/Baduk) game for iOS 26, featuring:

- **Expert AI**: Advanced AI using Apple Intelligence and Monte Carlo Tree Search
- **Modern Design**: Liquid Glass UI with iOS 26's latest visual features
- **Stunning Animations**: Fluid transitions and captivating intro sequence
- **Complete Rules**: Strict implementation of official Go rules
- **Multiple Board Sizes**: 9×9, 13×13, and 19×19
- **Statistics Tracking**: Comprehensive score history and analytics
- **Full Accessibility**: VoiceOver support and Dynamic Type

---

## 📋 Table of Contents

- [Features](#-features)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Building for App Store](#-building-for-app-store)
- [Testing](#-testing)
- [Localization](#-localization)
- [App Store Submission](#-app-store-submission)
- [License](#-license)

---

## ✨ Features

### Game Engine
- ✅ Complete Go rules implementation (capture, Ko, territory scoring)
- ✅ Area scoring system (Chinese rules)
- ✅ Suicide move detection
- ✅ Ko rule enforcement
- ✅ Dead stone identification
- ✅ Territory calculation
- ✅ Move validation
- ✅ Undo/Redo functionality

### AI Engine
- ✅ 5 difficulty levels (Beginner to Master)
- ✅ Monte Carlo Tree Search (MCTS) for expert play
- ✅ Opening book for common patterns
- ✅ Life and death analysis
- ✅ Territory evaluation
- ✅ Capture detection and strategy
- ✅ Async/await for non-blocking gameplay

### User Interface
- ✅ Liquid Glass design (iOS 26)
- ✅ Realistic board with wood texture
- ✅ 3D stone rendering with shadows
- ✅ Last move indicator
- ✅ Smooth animations
- ✅ Particle effects
- ✅ Confetti celebration
- ✅ Loading indicators
- ✅ Gradient backgrounds

### Features
- ✅ Three board sizes (9×9, 13×13, 19×19)
- ✅ Score tracking and history
- ✅ Statistics visualization with charts
- ✅ Game settings customization
- ✅ Audio effects
- ✅ Push notifications
- ✅ Dark mode support
- ✅ iPad optimization
- ✅ Landscape and portrait support

### Accessibility
- ✅ VoiceOver support
- ✅ Dynamic Type
- ✅ High contrast mode
- ✅ Reduce motion support
- ✅ Localization (Spanish & English)

---

## 📱 Requirements

- **Xcode:** 16.0 or later
- **iOS:** 26.0 or later
- **Swift:** 6.0
- **Devices:** iPhone, iPad
- **macOS:** 15.0+ (for development)

---

## 🚀 Installation

### 1. Clone the Repository

```bash
cd ~/Desktop/GO
# All files are already in the GoMaster directory
```

### 2. Generate App Icons

```bash
cd GoMaster/Assets
swift AppIcon-Generator.swift ./AppIcons
```

This will generate all required icon sizes for App Store submission.

### 3. Open in Xcode

```bash
cd ..
open GoMaster.xcodeproj
```

### 4. Configure Signing

1. Select the GoMaster target
2. Go to "Signing & Capabilities"
3. Select your development team
4. Ensure automatic signing is enabled

### 5. Build and Run

- Select your target device or simulator
- Press `Cmd + R` to build and run

---

## 🏗️ Architecture

GoMaster follows a clean, functional architecture:

```
┌─────────────────────────────────────────┐
│            SwiftUI Views                │
│  (ContentView, GameView, BoardView)     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         @StateObject Managers           │
│   (GameManager, AudioManager)           │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Game Engines                   │
│  (GoGameEngine, GoAIEngine)             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│            Data Models                  │
│  (GameState, Stone, Move, etc.)         │
└─────────────────────────────────────────┘
```

### Key Components

#### **GameManager** (`Managers/GameManager.swift`)
- Central state management
- Coordinates game flow
- Handles AI turns
- Manages scoring and persistence

#### **GoGameEngine** (`Game/GoGameEngine.swift`)
- Core game logic
- Rule enforcement
- Move validation
- Territory calculation

#### **GoAIEngine** (`Game/GoAIEngine.swift`)
- AI move calculation
- Monte Carlo Tree Search
- Position evaluation
- Strategy patterns

#### **GoBoardView** (`Views/GoBoardView.swift`)
- Board rendering
- Stone visualization
- Touch handling
- Animation effects

---

## 📁 Project Structure

```
GoMaster/
├── GoMasterApp.swift          # App entry point
├── Info.plist                 # App configuration
├── GoMaster.entitlements      # Capabilities
│
├── Models/
│   └── GameModels.swift       # Data structures
│
├── Game/
│   ├── GoGameEngine.swift     # Game logic
│   └── GoAIEngine.swift       # AI implementation
│
├── Managers/
│   ├── GameManager.swift      # State management
│   ├── AudioManager.swift     # Sound effects
│   └── NotificationManager.swift  # Push notifications
│
├── Views/
│   ├── IntroView.swift        # Animated intro
│   ├── ContentView.swift      # Main container
│   ├── GameView.swift         # Game screen
│   ├── GoBoardView.swift      # Board rendering
│   ├── GameOverView.swift     # Results screen
│   ├── ScoresView.swift       # Statistics
│   ├── SettingsView.swift     # Settings
│   └── NewGameSheet.swift     # New game config
│
├── Resources/
│   ├── Localizable.strings    # Spanish text
│   └── Localizable-en.strings # English text
│
├── Assets/
│   └── AppIcon-Generator.swift  # Icon generation
│
└── AppStore/
    └── AppStoreMetadata.md    # Store listing info
```

---

## 🔨 Building for App Store

### 1. Update Version Numbers

Edit `Info.plist`:
- `CFBundleShortVersionString`: "1.0.0"
- `CFBundleVersion`: "1"

### 2. Generate Icons

```bash
cd Assets
swift AppIcon-Generator.swift ./AppIcons
```

### 3. Configure Signing

1. Open project in Xcode
2. Select GoMaster target
3. Go to "Signing & Capabilities"
4. Set your Team and Bundle ID
5. Ensure "Automatically manage signing" is enabled

### 4. Archive Build

1. Select "Any iOS Device" as target
2. Product → Archive
3. Wait for archive to complete
4. Click "Distribute App"
5. Choose "App Store Connect"
6. Follow the wizard

### 5. Prepare Metadata

All metadata is in `AppStore/AppStoreMetadata.md`:
- App description
- Keywords
- Screenshots specs
- What's new
- Support information

---

## 🧪 Testing

### Unit Tests

```bash
# Run all tests
xcodebuild test -scheme GoMaster -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### UI Tests

```bash
# Run UI tests
xcodebuild test -scheme GoMasterUITests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### Manual Testing Checklist

- [ ] New game starts correctly
- [ ] All board sizes work (9×9, 13×13, 19×19)
- [ ] All difficulty levels work
- [ ] Stone placement is accurate
- [ ] Captures work correctly
- [ ] Ko rule is enforced
- [ ] Suicide moves are prevented
- [ ] Pass button works
- [ ] Undo button works
- [ ] Resign button works
- [ ] Game over triggers correctly
- [ ] Score calculation is accurate
- [ ] Statistics save correctly
- [ ] Sounds play appropriately
- [ ] Notifications work
- [ ] Dark mode works
- [ ] VoiceOver works
- [ ] Dynamic Type works
- [ ] iPad layout is correct
- [ ] Landscape mode works
- [ ] Memory doesn't leak
- [ ] No crashes occur

---

## 🌍 Localization

GoMaster supports:
- **Spanish** (Primary)
- **English** (Secondary)

### Adding New Languages

1. Create new `.strings` file:
   ```
   Resources/Localizable-[lang].strings
   ```

2. Add all keys from `Localizable.strings`

3. Update `Info.plist`:
   ```xml
   <key>CFBundleLocalizations</key>
   <array>
       <string>es</string>
       <string>en</string>
       <string>[new-lang]</string>
   </array>
   ```

4. Test with new language in Settings

---

## 📤 App Store Submission

### Prerequisites

- [x] Apple Developer account ($99/year)
- [x] App Store Connect access
- [x] Valid signing certificate
- [x] App ID created
- [x] All metadata prepared

### Submission Steps

1. **Create App in App Store Connect**
   - Go to appstoreconnect.apple.com
   - Click "My Apps" → "+"
   - Fill in basic information

2. **Upload Build**
   - Archive from Xcode
   - Upload to App Store Connect
   - Wait for processing (10-30 minutes)

3. **Complete Metadata**
   - Use `AppStore/AppStoreMetadata.md`
   - Add screenshots (see specs in metadata file)
   - Add app preview video (optional)
   - Set pricing (Free recommended)
   - Select categories

4. **Submit for Review**
   - Complete all required fields
   - Add demo account info
   - Add review notes
   - Submit

5. **Review Process**
   - Typically 1-3 days
   - Monitor App Store Connect
   - Respond to any feedback

### Screenshots Requirements

Generate screenshots for:
- iPhone 6.9" (2868×1320): **Required**
- iPhone 6.7" (2796×1290): **Required**
- iPhone 5.5" (2208×1242): Optional
- iPad Pro 12.9" (2048×2732): Optional

**Tip:** Use Xcode's screenshot feature or SimulatorCapture tool.

---

## 🎨 Design Guidelines

### Colors

```swift
// Primary colors
Primary Blue: #2E5BFF
Primary Purple: #8B5CF6
Primary Pink: #EC4899

// Board colors
Board Wood: #D4A574 to #C7986B
Grid Lines: Black 80% opacity

// Stones
Black Stone: Radial gradient (Gray 30% → Black)
White Stone: Radial gradient (White → Gray 30%)
```

### Typography

All text uses **San Francisco Pro**:
- Display: Titles and headings
- Text: Body content
- Rounded: Playful elements

### Spacing

- Small: 8pt
- Medium: 16pt
- Large: 24pt
- XLarge: 32pt

---

## 🐛 Known Issues

None currently! 🎉

---

## 📝 Changelog

### Version 1.0.0 (2025-01-20)
- Initial release
- Complete Go game implementation
- Expert AI with 5 difficulty levels
- Liquid Glass UI
- Score tracking
- Notifications
- Spanish and English localization

---

## 👥 Credits

- **Development:** GoMaster Team
- **Design:** iOS 26 Liquid Glass Design Language
- **AI:** Monte Carlo Tree Search algorithms
- **Inspiration:** The ancient game of Go (2500+ years old)

---

## 📄 License

© 2025 GoMaster Team. All rights reserved.

This is proprietary software. Unauthorized copying, distribution, or modification is prohibited.

---

## 📞 Support

- **Email:** support@gomaster.com
- **Website:** https://gomaster.com
- **Privacy Policy:** https://gomaster.com/privacy

---

## 🙏 Acknowledgments

- Apple for iOS 26 and Swift
- The Go community for preserving this beautiful game
- Beta testers for valuable feedback

---

<div align="center">

**Made with ❤️ and Swift**

[⬆ Back to Top](#gomaster---professional-go-game-for-ios-26)

</div>
