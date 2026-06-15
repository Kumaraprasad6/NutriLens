import SwiftUI

struct CircularProgressRing: View {
    let progress: Double
    let color: Color
    let lineWidth: CGFloat
    let size: CGFloat
    let showGlow: Bool
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        color: Color = AppTheme.Colors.primary,
        lineWidth: CGFloat = 12,
        size: CGFloat = 200,
        showGlow: Bool = true
    ) {
        self.progress = min(max(progress, 0), 1)
        self.color = color
        self.lineWidth = lineWidth
        self.size = size
        self.showGlow = showGlow
    }
    
    var body: some View {
        ZStack {
            // Background glow
            if showGlow && animatedProgress > 0.5 {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: size + 20, height: size + 20)
                    .blur(radius: 20)
                    .animation(.easeInOut(duration: 0.5), value: animatedProgress)
            }
            
            // Background track
            Circle()
                .stroke(Color(.systemGray5), lineWidth: lineWidth)
            
            // Progress arc
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: [color.opacity(0.8), color, color.opacity(0.9)],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedProgress)
        }
        .frame(width: size, height: size)
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        CircularProgressRing(progress: 0.75, color: AppTheme.Colors.calories, size: 200)
        CircularProgressRing(progress: 0.45, color: AppTheme.Colors.protein, lineWidth: 8, size: 120)
    }
    .padding()
}
