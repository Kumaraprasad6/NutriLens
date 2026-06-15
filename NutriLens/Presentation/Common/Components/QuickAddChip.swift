import SwiftUI

struct QuickAddChip: View {
    let food: FoodItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Text(EmojiHelper.emoji(for: food.name))
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(food.name)
                    .font(AppTheme.Typography.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(Int(food.nutrition.calories)) kcal")
                    .font(AppTheme.Typography.footnote)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                .fill(AppTheme.Colors.surface)
                .shadow(
                    color: AppTheme.Shadows.subtle.color,
                    radius: AppTheme.Shadows.subtle.radius,
                    x: AppTheme.Shadows.subtle.x,
                    y: AppTheme.Shadows.subtle.y
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                .stroke(AppTheme.Colors.primary.opacity(0.15), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.95 : (isAnimating ? 1.1 : 1.0))
        .animation(AppTheme.Animation.bouncy, value: isPressed)
        .animation(AppTheme.Animation.bouncy, value: isAnimating)
        .onTapGesture {
            isPressed = true
            isAnimating = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating = false
            }
            
            onTap()
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        QuickAddChip(
            food: FoodItem(name: "Apple", nutrition: NutritionInfo(calories: 95, protein: 0.5, carbs: 25, fats: 0.3)),
            onTap: { print("Tapped Apple") }
        )
        QuickAddChip(
            food: FoodItem(name: "Salad", nutrition: NutritionInfo(calories: 320, protein: 12, carbs: 18, fats: 8)),
            onTap: { print("Tapped Salad") }
        )
        QuickAddChip(
            food: FoodItem(name: "Avocado", nutrition: NutritionInfo(calories: 160, protein: 2, carbs: 9, fats: 15)),
            onTap: { print("Tapped Avocado") }
        )
    }
    .padding()
    .background(AppTheme.Colors.background)
}