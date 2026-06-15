import SwiftUI

enum AppTheme {
    // MARK: - Colors
    enum Colors {
        static let primary = Color(hex: "#FF6B35")
        static let primaryLight = Color(hex: "#FFF0EB")
        static let secondary = Color(hex: "#6E6E73")
        
        static let background = Color(hex: "#F5F5F0")
        static let surface = Color.white
        static let surfaceElevated = Color(hex: "#FAFAFA")
        static let groupedBackground = Color(.systemGroupedBackground)
        
        static let success = Color(hex: "#34C759")
        static let warning = Color(hex: "#FF9500")
        static let error = Color(hex: "#FF3B30")
        
        static let textPrimary = Color(hex: "#1A1A1A")
        static let textSecondary = Color(hex: "#6E6E73")
        static let textTertiary = Color(hex: "#A1A1A6")
        
        // Nutrient colors
        static let calories = Color(hex: "#FF6B35")
        static let protein = Color(hex: "#2E8B57")
        static let carbs = Color(hex: "#5B9BD5")
        static let fats = Color(hex: "#D4A017")
        static let fiber = Color(hex: "#34C759")
        static let sugar = Color(hex: "#FF9500")
        static let sodium = Color(hex: "#5AC8FA")
    }

    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    // MARK: - Corner Radius
    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    // MARK: - Typography
    enum Typography {
        static let fontFamily = "SF Pro Rounded"
        
        static let display: Font = .system(size: 48, weight: .bold, design: .rounded)
        static let title1: Font = .system(size: 28, weight: .bold, design: .rounded)
        static let title2: Font = .system(size: 22, weight: .semibold, design: .rounded)
        static let title3: Font = .system(size: 20, weight: .semibold, design: .rounded)
        static let body: Font = .system(size: 17, weight: .regular, design: .rounded)
        static let bodyMedium: Font = .system(size: 17, weight: .medium, design: .rounded)
        static let caption: Font = .system(size: 13, weight: .medium, design: .rounded)
        static let footnote: Font = .system(size: 12, weight: .regular, design: .rounded)
        static let largeNumber: Font = .system(size: 36, weight: .bold, design: .rounded)
        static let mediumNumber: Font = .system(size: 24, weight: .semibold, design: .rounded)
    }

    // MARK: - Shadows
    enum Shadows {
        static let card = ShadowStyle(
            color: Color.black.opacity(0.06),
            radius: 12,
            x: 0,
            y: 4
        )
        static let elevated = ShadowStyle(
            color: Color.black.opacity(0.08),
            radius: 16,
            x: 0,
            y: 6
        )
        static let subtle = ShadowStyle(
            color: Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 2
        )
    }

    // MARK: - Animation
    enum Animation {
        static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
        static let springSlow = SwiftUI.Animation.spring(response: 0.8, dampingFraction: 0.7)
        static let easeInOut = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let easeInOutSlow = SwiftUI.Animation.easeInOut(duration: 0.6)
        static let bouncy = SwiftUI.Animation.interpolatingSpring(stiffness: 100, damping: 10)
    }
}

// MARK: - Shadow Style
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers
extension View {
    /// Modern card style with soft shadow and rounded corners
    func nutriCard() -> some View {
        self
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xl))
            .shadow(
                color: AppTheme.Shadows.card.color,
                radius: AppTheme.Shadows.card.radius,
                x: AppTheme.Shadows.card.x,
                y: AppTheme.Shadows.card.y
            )
    }

    /// Glass morphism background effect
    func glassBackground() -> some View {
        self
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xl)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }

    /// Primary CTA button style
    func primaryButton() -> some View {
        self
            .font(AppTheme.Typography.bodyMedium)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
            .shadow(
                color: AppTheme.Colors.primary.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
    }

    /// Secondary button style
    func secondaryButton() -> some View {
        self
            .font(AppTheme.Typography.bodyMedium)
            .foregroundStyle(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.primaryLight)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    /// Press feedback animation
    func pressable() -> some View {
        self
            .scaleEffect(1.0)
            .animation(AppTheme.Animation.spring, value: UUID())
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}