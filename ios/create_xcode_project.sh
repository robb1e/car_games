#!/bin/bash

# This script helps create an Xcode project for the Car Games app

echo "Creating Car Games Xcode Project..."

# Create project directory structure
mkdir -p CarGames/CarGames

# Copy Swift files to project directory
cp CarGamesApp.swift CarGames/CarGames/
cp ContentView.swift CarGames/CarGames/
cp RainbowRoadView.swift CarGames/CarGames/
cp TwentyQuestionsView.swift CarGames/CarGames/
cp FindMeView.swift CarGames/CarGames/

# Create a basic Info.plist
cat > CarGames/CarGames/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>Car Games</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.CarGames</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>
EOF

echo "Project structure created!"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. Create a new iOS App project with SwiftUI"
echo "3. Replace the default files with the ones in CarGames/CarGames/"
echo "4. Build and run!"