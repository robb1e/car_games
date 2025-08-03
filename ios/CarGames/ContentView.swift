import SwiftUI

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}