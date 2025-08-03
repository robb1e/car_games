// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "CarGames",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CarGames",
            targets: ["CarGames"]),
    ],
    targets: [
        .target(
            name: "CarGames",
            dependencies: [],
            path: ".",
            sources: [
                "CarGamesApp.swift",
                "ContentView.swift",
                "RainbowRoadView.swift",
                "TwentyQuestionsView.swift",
                "FindMeView.swift"
            ]
        )
    ]
)