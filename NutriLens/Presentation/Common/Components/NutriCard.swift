import SwiftUI

struct NutriCard<Content: View>: View {
    let content: Content
    let isPressable: Bool
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    
    init(
        isPressable: Bool = true,
        onTap: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.isPressable = isPressable
        self.onTap = onTap
    }
    
    var body: some View {
        content
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xl))
            .shadow(
                color: AppTheme.Shadows.card.color,
                radius: AppTheme.Shadows.card.radius,
                x: AppTheme.Shadows.card.x,
                y: AppTheme.Shadows.card.y
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(AppTheme.Animation.spring, value: isPressed)
            .opacity(isPressed ? 0.9 : 1.0)
            .onTapGesture {
                if isPressable {
                    withAnimation(AppTheme.Animation.spring) {
                        isPressed = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isPressed = false
                    }
                    onTap?()
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        NutriCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hello")
                    .font(AppTheme.Typography.title2)
                Text("This is a card")
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
        
        NutriCard(isPressable: true, onTap: {
            print("Tapped!")
        }) {
            HStack {
                Text("Pressable Card")
                    .font(AppTheme.Typography.bodyMedium)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}