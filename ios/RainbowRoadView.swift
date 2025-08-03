import SwiftUI

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

struct RainbowRoadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RainbowRoadView()
        }
    }
}