import SwiftUI

struct FoodLogRow: View {
    let entry: FoodItem
    let onDelete: (() -> Void)?
    
    @State private var isPressed = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: AppTheme.Spacing.md) {
                // Emoji or Image
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.primaryLight)
                        .frame(width: 48, height: 48)
                    
                    Text(EmojiHelper.emoji(for: entry.name))
                        .font(.title3)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.name)
                        .font(AppTheme.Typography.bodyMedium)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("\(Int(entry.nutrition.calories)) kcal")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        
                        if entry.nutrition.protein > 0 {
                            Text("• \(Int(entry.nutrition.protein))g P")
                                .font(AppTheme.Typography.caption)
                                .foregroundStyle(AppTheme.Colors.textTertiary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.textTertiary)
            }
            .padding(.vertical, AppTheme.Spacing.sm)
            .contentShape(Rectangle())
            .offset(x: offset)
            .opacity(offset == 0 ? 1 : 0.5)
            .animation(AppTheme.Animation.easeInOut, value: offset)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < -100, onDelete != nil {
                            withAnimation(AppTheme.Animation.easeInOut) {
                                offset = -geometry.size.width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onDelete?()
                            }
                        }
                    }
            )
            .onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
        .frame(height: 64)
    }
}

#Preview {
    VStack(spacing: 0) {
        FoodLogRow(
            entry: FoodItem(name: "Caesar Salad", nutrition: NutritionInfo(calories: 320, protein: 12, carbs: 18, fats: 8)),
            onDelete: { print("Deleted salad") }
        )
        Divider()
        FoodLogRow(
            entry: FoodItem(name: "Grilled Chicken", nutrition: NutritionInfo(calories: 450, protein: 35, carbs: 5, fats: 12)),
            onDelete: { print("Deleted chicken") }
        )
        Divider()
        FoodLogRow(
            entry: FoodItem(name: "Greek Yogurt", nutrition: NutritionInfo(calories: 120, protein: 15, carbs: 8, fats: 0)),
            onDelete: { print("Deleted yogurt") }
        )
    }
    .padding(.horizontal)
    .background(AppTheme.Colors.background)
}