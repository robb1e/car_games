import SwiftUI

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

struct FindMeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FindMeView()
        }
    }
}