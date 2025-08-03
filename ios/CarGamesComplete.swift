// Car Games - Complete Single File Version
// Copy this entire file into a new SwiftUI iOS App project

import SwiftUI

@main
struct CarGamesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Main Menu

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Car Games")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    NavigationLink(destination: RainbowRoadView()) {
                        GameButton(title: "Rainbow Road", 
                                 subtitle: "Spot vehicles by color",
                                 systemImage: "car.fill",
                                 color: .purple)
                    }
                    
                    NavigationLink(destination: TwentyQuestionsView()) {
                        GameButton(title: "20 Questions", 
                                 subtitle: "Guess the mystery item",
                                 systemImage: "questionmark.circle.fill",
                                 color: .orange)
                    }
                    
                    NavigationLink(destination: FindMeView()) {
                        GameButton(title: "Find Me", 
                                 subtitle: "Spot items to score points",
                                 systemImage: "eye.fill",
                                 color: .green)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GameButton: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

// MARK: - Rainbow Road Game

struct RainbowRoadView: View {
    @State private var currentColorIndex = 0
    @State private var foundColors: Set<Int> = []
    @State private var skippedColors: Set<Int> = []
    @State private var isGameComplete = false
    
    let rainbowColors: [(name: String, color: Color)] = [
        ("Red", .red),
        ("Orange", .orange),
        ("Yellow", .yellow),
        ("Green", .green),
        ("Blue", .blue),
        ("Indigo", Color(red: 0.29, green: 0, blue: 0.51)),
        ("Violet", .purple)
    ]
    
    var currentColor: (name: String, color: Color) {
        rainbowColors[currentColorIndex]
    }
    
    var nextAvailableColorIndex: Int? {
        for i in 0..<rainbowColors.count {
            let index = (currentColorIndex + 1 + i) % rainbowColors.count
            if !foundColors.contains(index) {
                return index
            }
        }
        return nil
    }
    
    var body: some View {
        VStack {
            if isGameComplete {
                VStack(spacing: 20) {
                    Text("🌈 Congratulations! 🌈")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("You found all the rainbow colors!")
                        .font(.title2)
                    
                    Button(action: resetGame) {
                        Text("Play Again")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 30) {
                    Text("Find a \(currentColor.name) Vehicle")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    ZStack {
                        Circle()
                            .fill(currentColor.color)
                            .frame(width: 250, height: 250)
                            .shadow(radius: 10)
                        
                        Image(systemName: "car.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 20) {
                        Button(action: skipColor) {
                            Label("Skip", systemImage: "forward.fill")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(foundColors.count + skippedColors.count == rainbowColors.count - 1)
                        
                        Button(action: foundColor) {
                            Label("Found It!", systemImage: "checkmark.circle.fill")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    ProgressView(value: Double(foundColors.count), total: Double(rainbowColors.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.horizontal)
                    
                    Text("\(foundColors.count) of \(rainbowColors.count) colors found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Rainbow Road")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func foundColor() {
        foundColors.insert(currentColorIndex)
        skippedColors.remove(currentColorIndex)
        
        if foundColors.count == rainbowColors.count {
            isGameComplete = true
        } else if let nextIndex = nextAvailableColorIndex {
            currentColorIndex = nextIndex
        }
    }
    
    func skipColor() {
        if !foundColors.contains(currentColorIndex) {
            skippedColors.insert(currentColorIndex)
        }
        
        if let nextIndex = nextAvailableColorIndex {
            currentColorIndex = nextIndex
        }
    }
    
    func resetGame() {
        currentColorIndex = 0
        foundColors = []
        skippedColors = []
        isGameComplete = false
    }
}

// MARK: - 20 Questions Game

struct TwentyQuestionsView: View {
    @State private var currentItemIndex = 0
    @State private var questionCount = 20
    @State private var isGameActive = false
    @State private var showAnswer = false
    
    let items = [
        "Elephant", "Penguin", "Butterfly", "Shark", "Kangaroo",
        "Owl", "Dolphin", "Tiger", "Hamster", "Octopus",
        "Giraffe", "Bee", "Turtle", "Eagle", "Frog",
        "Horse", "Spider", "Whale", "Rabbit", "Snake",
        "Pizza", "Ice cream", "Banana", "Chocolate", "Coffee",
        "Sandwich", "Apple", "Pasta", "Cookies", "Orange juice",
        "Cheese", "Popcorn", "Hamburger", "Cake", "Milk"
    ]
    
    var currentItem: String {
        items[currentItemIndex]
    }
    
    var itemEmoji: String {
        switch currentItem.lowercased() {
        case "elephant": return "🐘"
        case "penguin": return "🐧"
        case "butterfly": return "🦋"
        case "shark": return "🦈"
        case "kangaroo": return "🦘"
        case "owl": return "🦉"
        case "dolphin": return "🐬"
        case "tiger": return "🐅"
        case "hamster": return "🐹"
        case "octopus": return "🐙"
        case "giraffe": return "🦒"
        case "bee": return "🐝"
        case "turtle": return "🐢"
        case "eagle": return "🦅"
        case "frog": return "🐸"
        case "horse": return "🐴"
        case "spider": return "🕷️"
        case "whale": return "🐳"
        case "rabbit": return "🐰"
        case "snake": return "🐍"
        case "pizza": return "🍕"
        case "ice cream": return "🍨"
        case "banana": return "🍌"
        case "chocolate": return "🍫"
        case "coffee": return "☕"
        case "sandwich": return "🥪"
        case "apple": return "🍎"
        case "pasta": return "🍝"
        case "cookies": return "🍪"
        case "orange juice": return "🥤"
        case "cheese": return "🧀"
        case "popcorn": return "🍿"
        case "hamburger": return "🍔"
        case "cake": return "🍰"
        case "milk": return "🥛"
        default: return "❓"
        }
    }
    
    var body: some View {
        VStack {
            if !isGameActive {
                VStack(spacing: 30) {
                    Text("20 Questions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("The person holding the device will see a word.\nOthers must guess it using yes/no questions!")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button(action: startGame) {
                        Text("Start Game")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            } else {
                VStack(spacing: 30) {
                    if showAnswer {
                        VStack(spacing: 20) {
                            Text(itemEmoji)
                                .font(.system(size: 100))
                            
                            Text(currentItem)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .transition(.scale)
                    } else {
                        VStack(spacing: 10) {
                            Text("Your word is:")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text(currentItem)
                                .font(.system(size: 50))
                                .fontWeight(.bold)
                                .foregroundColor(.orange)
                            
                            Text(itemEmoji)
                                .font(.system(size: 80))
                        }
                    }
                    
                    ZStack {
                        Circle()
                            .strokeBorder(Color.orange.opacity(0.3), lineWidth: 10)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(questionCount) / 20)
                            .stroke(
                                questionCount > 5 ? Color.orange : Color.red,
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut, value: questionCount)
                        
                        VStack {
                            Text("\(questionCount)")
                                .font(.system(size: 60))
                                .fontWeight(.bold)
                                .foregroundColor(questionCount > 5 ? .primary : .red)
                            
                            Text("questions left")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 20) {
                        Button(action: decrementQuestion) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                        }
                        .disabled(questionCount <= 0)
                        
                        Button(action: toggleAnswer) {
                            Image(systemName: showAnswer ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: incrementQuestion) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                        }
                        .disabled(questionCount >= 20)
                    }
                    
                    HStack(spacing: 20) {
                        Button(action: resetGame) {
                            Text("New Word")
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: endGame) {
                            Text("End Game")
                                .font(.title3)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("20 Questions")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func startGame() {
        currentItemIndex = Int.random(in: 0..<items.count)
        questionCount = 20
        showAnswer = false
        isGameActive = true
    }
    
    func resetGame() {
        currentItemIndex = Int.random(in: 0..<items.count)
        questionCount = 20
        showAnswer = false
    }
    
    func endGame() {
        isGameActive = false
    }
    
    func decrementQuestion() {
        if questionCount > 0 {
            questionCount -= 1
        }
    }
    
    func incrementQuestion() {
        if questionCount < 20 {
            questionCount += 1
        }
    }
    
    func toggleAnswer() {
        showAnswer.toggle()
    }
}

// MARK: - Find Me Game

struct FindMeView: View {
    @State private var numberOfPlayers = 2
    @State private var playerScores: [Int] = [0, 0]
    @State private var currentItemIndex = 0
    @State private var isGameActive = false
    @State private var showingItem = false
    @State private var gameStarted = false
    
    let items = [
        "Bus", "Roundabout", "Sheep", "Church", "Postbox",
        "Boat", "Train", "Bridge", "Castle", "Windmill",
        "Horse", "Telephone box", "Motorway services", "Speed camera", "Blue plaque"
    ]
    
    var currentItem: String {
        items[currentItemIndex]
    }
    
    var itemEmoji: String {
        switch currentItem.lowercased() {
        case "bus": return "🚌"
        case "roundabout": return "🔄"
        case "sheep": return "🐑"
        case "church": return "⛪"
        case "postbox": return "📮"
        case "boat": return "⛵"
        case "train": return "🚂"
        case "bridge": return "🌉"
        case "castle": return "🏰"
        case "windmill": return "🌬️"
        case "horse": return "🐴"
        case "telephone box": return "☎️"
        case "motorway services": return "⛽"
        case "speed camera": return "📷"
        case "blue plaque": return "🔵"
        default: return "❓"
        }
    }
    
    var winningPlayer: Int? {
        playerScores.enumerated().first(where: { $0.element >= 10 })?.offset
    }
    
    var body: some View {
        VStack {
            if !gameStarted {
                VStack(spacing: 30) {
                    Text("Find Me")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Players race to spot items first!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 20) {
                        Text("Number of Players")
                            .font(.headline)
                        
                        Picker("Players", selection: $numberOfPlayers) {
                            ForEach(2...6, id: \.self) { number in
                                Text("\(number) Players").tag(number)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: numberOfPlayers) { newValue in
                            playerScores = Array(repeating: 0, count: newValue)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: startGame) {
                        Text("Start Game")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            } else if let winner = winningPlayer {
                VStack(spacing: 30) {
                    Text("🎉 Game Over! 🎉")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Player \(winner + 1) Wins!")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Button(action: resetGame) {
                        Text("Play Again")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            } else {
                VStack(spacing: 20) {
                    if showingItem {
                        VStack(spacing: 20) {
                            Text("Find this:")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text(itemEmoji)
                                .font(.system(size: 100))
                            
                            Text(currentItem)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(20)
                    } else {
                        VStack(spacing: 10) {
                            Text("Ready?")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Press below to reveal the item")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(0..<numberOfPlayers, id: \.self) { playerIndex in
                                PlayerScoreRow(
                                    playerNumber: playerIndex + 1,
                                    score: playerScores[playerIndex],
                                    onScorePoint: {
                                        if showingItem {
                                            playerScores[playerIndex] += 1
                                            nextItem()
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    if !showingItem {
                        Button(action: { showingItem = true }) {
                            Text("Show Item")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                        .padding(.horizontal)
                    }
                    
                    Button(action: resetGame) {
                        Text("End Game")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Find Me")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func startGame() {
        gameStarted = true
        playerScores = Array(repeating: 0, count: numberOfPlayers)
        currentItemIndex = Int.random(in: 0..<items.count)
        showingItem = false
    }
    
    func resetGame() {
        gameStarted = false
        showingItem = false
    }
    
    func nextItem() {
        showingItem = false
        currentItemIndex = Int.random(in: 0..<items.count)
    }
}

struct PlayerScoreRow: View {
    let playerNumber: Int
    let score: Int
    let onScorePoint: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Player \(playerNumber)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack {
                    ForEach(0..<10, id: \.self) { index in
                        Circle()
                            .fill(index < score ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 25, height: 25)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onScorePoint) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}