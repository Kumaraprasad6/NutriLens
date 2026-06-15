import SwiftUI

struct SearchResultRow: View {
    let food: IFCTFoodItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.md) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(food.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)

                    if !food.localNameDisplay.isEmpty {
                        Text(food.localNameDisplay)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text(food.group)
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(AppTheme.Colors.primary.opacity(0.1))
                            .foregroundColor(AppTheme.Colors.primary)
                            .clipShape(Capsule())

                        Text("\(Int(food.energy)) kcal per 100g")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SearchResultRow(
        food: IFCTFoodItem(
            code: "A001",
            name: "Rice, raw",
            localNames: "H. Chawal; Tam. Arisi",
            group: "Cereals and Millets",
            energy: 345,
            protein: 6.8,
            fat: 0.5,
            carbs: 78.2
        ),
        onTap: {}
    )
    .padding()
}
