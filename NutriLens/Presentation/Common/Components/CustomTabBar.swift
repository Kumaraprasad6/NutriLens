import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab bar background with 4 tabs
            HStack(spacing: 0) {
                TabBarButton(tab: .home, selectedTab: $selectedTab)
                TabBarButton(tab: .log, selectedTab: $selectedTab)
                
                // Spacer to push camera gap wider
                Spacer()
                    .frame(width: 60)
                
                TabBarButton(tab: .analysis, selectedTab: $selectedTab)
                TabBarButton(tab: .profile, selectedTab: $selectedTab)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.top, AppTheme.Spacing.sm)
            .padding(.bottom, AppTheme.Spacing.lg)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea(edges: .bottom)
            )
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundStyle(Color(.systemGray4)),
                alignment: .top
            )
            
            // Floating camera button - centered above tab bar
            Button {
                withAnimation(AppTheme.Animation.spring) {
                    selectedTab = .camera
                }
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
            } label: {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 56, height: 56)
                        .shadow(
                            color: AppTheme.Colors.primary.opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                    
                    Image(systemName: "camera.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .offset(y: -20) // Float above tab bar
        }
    }
}

struct TabBarButton: View {
    let tab: AppTab
    @Binding var selectedTab: AppTab
    
    @State private var isPressed = false
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            isPressed = true
            withAnimation(AppTheme.Animation.spring) {
                selectedTab = tab
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isPressed = false
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.iconFill : tab.icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.textTertiary)
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(AppTheme.Animation.spring, value: isPressed)
    }
}

enum AppTab: String, CaseIterable {
    case home = "Home"
    case log = "Log"
    case camera = ""
    case analysis = "Analysis"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home:
            return "house"
        case .log:
            return "clock"
        case .camera:
            return "camera.fill"
        case .analysis:
            return "chart.pie"
        case .profile:
            return "person"
        }
    }
    
    var iconFill: String {
        switch self {
        case .home:
            return "house.fill"
        case .log:
            return "clock.fill"
        case .camera:
            return "camera.fill"
        case .analysis:
            return "chart.pie.fill"
        case .profile:
            return "person.fill"
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab: AppTab = .home
        
        var body: some View {
            ZStack(alignment: .bottom) {
                Color.gray.opacity(0.2)
                    .ignoresSafeArea()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    return PreviewWrapper()
}
