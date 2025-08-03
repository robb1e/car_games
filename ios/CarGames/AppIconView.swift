import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.0, green: 0.48, blue: 1.0),  // iOS blue
                    Color(red: 0.35, green: 0.78, blue: 0.98) // Light blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 8) {
                // Rainbow arc
                HStack(spacing: 2) {
                    ForEach([Color.red, Color.orange, Color.yellow, Color.green, Color.blue, Color.purple], id: \.self) { color in
                        Rectangle()
                            .fill(color)
                            .frame(width: 8, height: 20)
                            .cornerRadius(4)
                    }
                }
                .offset(y: -15)
                
                // Car icon
                Image(systemName: "car.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
                
                // Game elements
                HStack(spacing: 12) {
                    // Question mark for 20 Questions
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.orange)
                        .background(Circle().fill(.white).frame(width: 20, height: 20))
                    
                    // Eye for Find Me
                    Image(systemName: "eye.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.green)
                        .background(Circle().fill(.white).frame(width: 20, height: 20))
                }
                .offset(y: 10)
            }
        }
        .frame(width: 1024, height: 1024)
        .clipShape(RoundedRectangle(cornerRadius: 180)) // iOS app icon corner radius
    }
}

struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            AppIconView()
                .frame(width: 200, height: 200)
                .shadow(radius: 10)
            
            Text("Car Games App Icon")
                .font(.headline)
            
            Text("Tap to copy design or export as image")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    AppIconPreview()
}