import SwiftUI

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

struct TwentyQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TwentyQuestionsView()
        }
    }
}