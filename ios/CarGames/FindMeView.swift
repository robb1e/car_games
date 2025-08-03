import SwiftUI

struct FindMeView: View {
    @State private var numberOfPlayers = 2
    @State private var playerScores: [Int] = [0, 0]
    @State private var playerNames: [String] = ["Player 1", "Player 2"]
    @State private var currentItemIndex = 0
    @State private var isGameActive = false
    @State private var showingItem = false
    @State private var gameStarted = false
    @State private var teamScore = 0
    
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
        if numberOfPlayers == 1 {
            return teamScore >= 10 ? 0 : nil
        } else {
            return playerScores.enumerated().first(where: { $0.element >= 10 })?.offset
        }
    }
    
    var body: some View {
        VStack {
            if !gameStarted {
                VStack(spacing: 30) {
                    Text("Find Me")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(numberOfPlayers == 1 ? "Team up to spot items!" : "Players race to spot items first!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 20) {
                        Text("Number of Players")
                            .font(.headline)
                        
                        Picker("Players", selection: $numberOfPlayers) {
                            Text("1 Team").tag(1)
                            ForEach(2...6, id: \.self) { number in
                                Text("\(number) Players").tag(number)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: numberOfPlayers) { newValue in
                            DispatchQueue.main.async {
                                playerScores = Array(repeating: 0, count: newValue)
                                if newValue == 1 {
                                    playerNames = ["Team"]
                                } else {
                                    playerNames = (1...newValue).map { "Player \($0)" }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if numberOfPlayers > 1 {
                        VStack(spacing: 15) {
                            Text("Player Names")
                                .font(.headline)
                            
                            ForEach(0..<min(numberOfPlayers, playerNames.count), id: \.self) { index in
                                TextField("Player \(index + 1)", text: $playerNames[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    
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
                    
                    Text(numberOfPlayers == 1 ? "Great teamwork!" : "\(playerNames[winner]) Wins!")
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
                    
                    if numberOfPlayers == 1 {
                        VStack(spacing: 20) {
                            Text("Team Score: \(teamScore)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            
                            Button(action: {
                                teamScore += 1
                                nextItem()
                            }) {
                                Text("Found It!")
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
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(0..<numberOfPlayers, id: \.self) { playerIndex in
                                    PlayerScoreRow(
                                        playerName: playerNames[playerIndex],
                                        score: playerScores[playerIndex],
                                        onScorePoint: {
                                            playerScores[playerIndex] += 1
                                            nextItem()
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
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
        teamScore = 0
        currentItemIndex = Int.random(in: 0..<items.count)
        showingItem = true
    }
    
    func resetGame() {
        gameStarted = false
        showingItem = false
        teamScore = 0
    }
    
    func nextItem() {
        currentItemIndex = Int.random(in: 0..<items.count)
    }
}

struct PlayerScoreRow: View {
    let playerName: String
    let score: Int
    let onScorePoint: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(playerName)
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