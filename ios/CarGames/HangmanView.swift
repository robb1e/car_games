import SwiftUI

struct HangmanView: View {
    @State private var currentPhraseIndex = 0
    @State private var guessedLetters: Set<Character> = []
    @State private var isGameActive = false
    @State private var gameState: GameState = .playing
    @State private var incorrectGuesses = 0
    @State private var currentGuess = ""
    @FocusState private var isTextFieldFocused: Bool
    
    let maxIncorrectGuesses = 12
    
    enum GameState {
        case playing
        case won
        case lost
    }
    
    let phrases = [
        "Road trip",
        "Pack your bags",
        "Lets go to the beach",
        "Mountain biking",
        "City break",
        "Swimming pool",
        "Airport terminal",
        "Train station",
        "Theme park",
        "Rollercoaster",
        "Museum"
    ]
    
    var currentPhrase: String {
        phrases[currentPhraseIndex]
    }
    
    var displayPhrase: String {
        currentPhrase.map { char in
            if char.isLetter {
                return guessedLetters.contains(char.lowercased().first!) ? String(char) : "_"
            } else if char == " " {
                return "/"
            } else {
                return String(char)
            }
        }.joined(separator: " ")
    }
    
    var isWordComplete: Bool {
        currentPhrase.lowercased().allSatisfy { char in
            !char.isLetter || guessedLetters.contains(char)
        }
    }
    
    var body: some View {
        VStack {
            if !isGameActive {
                startGameView
            } else {
                gameView
            }
        }
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: isWordComplete) { complete in
            if complete && gameState == .playing {
                gameState = .won
            }
        }
        .onChange(of: incorrectGuesses) { count in
            if count >= maxIncorrectGuesses && gameState == .playing {
                gameState = .lost
            }
        }
    }
    
    var startGameView: some View {
        VStack(spacing: 30) {
            Text("Hangman")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Guess the phrase letter by letter.\nBe careful - too many wrong guesses and you lose!")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal)
        }
    }
    
    var gameView: some View {
        VStack(spacing: 20) {
            HangmanDrawing(incorrectGuesses: incorrectGuesses)
                .frame(height: 200)
            
            Text(displayPhrase)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            if gameState == .won {
                Text("🎉 You Won! 🎉")
                    .font(.title)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            } else if gameState == .lost {
                VStack {
                    Text("💀 Game Over 💀")
                        .font(.title)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    
                    Text("The phrase was: \(currentPhrase)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(spacing: 15) {
                    Text("Incorrect guesses: \(incorrectGuesses)/\(maxIncorrectGuesses)")
                        .font(.headline)
                        .foregroundColor(incorrectGuesses > 3 ? .red : .primary)
                    
                    if !guessedLetters.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Guessed letters:")
                                .font(.headline)
                            
                            let columns = Array(repeating: GridItem(.adaptive(minimum: 40), spacing: 8), count: 1)
                            LazyVGrid(columns: columns, spacing: 8) {
                                ForEach(Array(guessedLetters.sorted()), id: \.self) { letter in
                                    Text(String(letter.uppercased()))
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            currentPhrase.lowercased().contains(letter) ? Color.green : Color.red
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 10) {
                        TextField("Type a letter", text: $currentGuess)
                            .font(.title2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .focused($isTextFieldFocused)
                            .onChange(of: currentGuess) { newValue in
                                // Filter to only letters
                                let filtered = newValue.filter { $0.isLetter }
                                
                                if let letter = filtered.first {
                                    let lowercaseLetter = Character(letter.lowercased())
                                    
                                    // Only process if it's a new guess
                                    if !guessedLetters.contains(lowercaseLetter) && gameState == .playing {
                                        guessLetter(lowercaseLetter)
                                    }
                                }
                                
                                // Clear the text field immediately
                                currentGuess = ""
                                
                                // Keep focus for continuous typing
                                if gameState == .playing {
                                    isTextFieldFocused = true
                                }
                            }
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal)
                }
            }
            
            HStack(spacing: 20) {
                Button(action: newGame) {
                    Text("New Phrase")
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
        .padding()
    }
    
    func startGame() {
        currentPhraseIndex = Int.random(in: 0..<phrases.count)
        guessedLetters.removeAll()
        incorrectGuesses = 0
        gameState = .playing
        isGameActive = true
        currentGuess = ""
        isTextFieldFocused = true
    }
    
    func newGame() {
        currentPhraseIndex = Int.random(in: 0..<phrases.count)
        guessedLetters.removeAll()
        incorrectGuesses = 0
        gameState = .playing
        currentGuess = ""
        isTextFieldFocused = true
    }
    
    func endGame() {
        isGameActive = false
    }
    
    func guessLetter(_ letter: Character) {
        guard !guessedLetters.contains(letter) && gameState == .playing else { return }
        
        guessedLetters.insert(letter)
        
        if !currentPhrase.lowercased().contains(letter) {
            incorrectGuesses += 1
        }
    }
}

struct HangmanDrawing: View {
    let incorrectGuesses: Int
    
    var body: some View {
        ZStack {
            Canvas { context, size in
                let width = size.width
                let height = size.height
                
                // Base
                if incorrectGuesses >= 1 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.1, y: height * 0.9))
                            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.9))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Pole
                if incorrectGuesses >= 2 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.2, y: height * 0.9))
                            path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.1))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Top beam
                if incorrectGuesses >= 3 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.2, y: height * 0.1))
                            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.1))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Floor to pole brace (diagonal support)
                if incorrectGuesses >= 4 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.3, y: height * 0.9))
                            path.addLine(to: CGPoint(x: width * 0.2, y: height * 0.7))
                        },
                        with: .color(.black),
                        lineWidth: 3
                    )
                }
                
                // Vertical to horizontal brace (corner support)
                if incorrectGuesses >= 5 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.2, y: height * 0.25))
                            path.addLine(to: CGPoint(x: width * 0.35, y: height * 0.1))
                        },
                        with: .color(.black),
                        lineWidth: 3
                    )
                }
                
                // Noose
                if incorrectGuesses >= 6 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.1))
                            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.25))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Head
                if incorrectGuesses >= 7 {
                    context.stroke(
                        Path { path in
                            path.addEllipse(in: CGRect(
                                x: width * 0.55,
                                y: height * 0.25,
                                width: width * 0.1,
                                height: height * 0.1
                            ))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Body
                if incorrectGuesses >= 8 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.35))
                            path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.65))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Left arm
                if incorrectGuesses >= 9 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.45))
                            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.45))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Right arm
                if incorrectGuesses >= 10 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.45))
                            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.45))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Left leg
                if incorrectGuesses >= 11 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.65))
                            path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.8))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
                
                // Right leg (final - game over)
                if incorrectGuesses >= 12 {
                    context.stroke(
                        Path { path in
                            path.move(to: CGPoint(x: width * 0.6, y: height * 0.65))
                            path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.8))
                        },
                        with: .color(.black),
                        lineWidth: 4
                    )
                }
            }
        }
    }
}

struct HangmanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HangmanView()
        }
    }
}