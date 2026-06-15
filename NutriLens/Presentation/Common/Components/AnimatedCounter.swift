import SwiftUI

struct AnimatedCounter: View {
    let value: Int
    let font: Font
    let color: Color
    let duration: Double
    
    @State private var animatedValue: Int = 0
    
    init(
        value: Int,
        font: Font = AppTheme.Typography.largeNumber,
        color: Color = AppTheme.Colors.textPrimary,
        duration: Double = 1.2
    ) {
        self.value = value
        self.font = font
        self.color = color
        self.duration = duration
    }
    
    var body: some View {
        Text("\(animatedValue)")
            .font(font)
            .foregroundStyle(color)
            .onAppear {
                animatedValue = value
            }
            .onChange(of: value) { oldValue, newValue in
                animateValue()
            }
    }
    
    private func animateValue() {
        let startValue = Double(animatedValue)
        let endValue = Double(value)
        let diff = endValue - startValue
        
        let steps = max(min(Int(abs(diff)), 120), 1)
        let stepDuration = duration / Double(steps)
        
        for i in 0..<steps {
            let progress = Double(i + 1) / Double(steps)
            let currentValue = startValue + (diff * progress)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * stepDuration) {
                self.animatedValue = Int(currentValue.rounded())
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        AnimatedCounter(value: 1240, font: AppTheme.Typography.display, color: AppTheme.Colors.primary)
        AnimatedCounter(value: 456, font: AppTheme.Typography.mediumNumber, color: AppTheme.Colors.protein)
    }
    .padding()
}
