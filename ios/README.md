# Car Games iOS App

This is a collection of three car games for iOS, built with SwiftUI.

## Games Included

1. **Rainbow Road** - Spot vehicles by color following the rainbow sequence
2. **20 Questions** - Guess the mystery item with yes/no questions
3. **Find Me** - Competitive spotting game for 2-6 players

## How to Run

### Option 1: Using Xcode (Recommended)

1. Open Xcode
2. Create a new iOS App project:
   - Product Name: CarGames
   - Interface: SwiftUI
   - Language: Swift
3. Replace the generated `ContentView.swift` with the one in this directory
4. Add the other Swift files to the project:
   - `RainbowRoadView.swift`
   - `TwentyQuestionsView.swift`
   - `FindMeView.swift`
5. Build and run the app

### Option 2: Using Swift Playgrounds on iPad

1. Create a new App in Swift Playgrounds
2. Copy the code from each Swift file into the playground
3. Run the playground

### Option 3: Command Line Build

```bash
# Navigate to the ios directory
cd /Users/robbieclutton/workspace/car_games/ios

# Build using xcodebuild (requires Xcode Command Line Tools)
xcodebuild -scheme CarGames -sdk iphonesimulator -configuration Debug
```

## Files Structure

- `CarGamesApp.swift` - Main app entry point
- `ContentView.swift` - Main menu with navigation
- `RainbowRoadView.swift` - Rainbow Road game
- `TwentyQuestionsView.swift` - 20 Questions game  
- `FindMeView.swift` - Find Me game

## Requirements

- iOS 16.0 or later
- Xcode 14.0 or later (for development)
- Works on iPhone and iPad
- No internet connection required