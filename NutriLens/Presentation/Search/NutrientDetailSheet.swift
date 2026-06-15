import SwiftUI

struct NutrientDetailSheet: View {
    @Environment(\.dismiss) private var dismiss

    let food: IFCTFoodItem
    let onSelect: (IFCTFoodItem) -> Void

    @State private var selectedPortion: IndianPortion = IndianPortionMapping.roti
    @State private var customGrams: String = "100"
    @State private var useCustomGrams: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    foodHeaderSection
                    portionSelectorSection
                    nutritionSection
                    selectButtonSection
                }
                .padding()
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Food Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var foodHeaderSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Text(food.name)
                .font(.system(size: 24, weight: .bold))
                .multilineTextAlignment(.center)

            if !food.localNameDisplay.isEmpty {
                Text(food.localNameDisplay)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Text(food.group)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(AppTheme.Colors.primary.opacity(0.1))
                .foregroundColor(AppTheme.Colors.primary)
                .clipShape(Capsule())

            Text("\(Int(food.energy)) kcal per 100g")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, AppTheme.Spacing.md)
    }

    private var portionSelectorSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Portion")
                .font(.system(size: 16, weight: .semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(IndianPortionMapping.allPortions, id: \.name) { portion in
                        Button(action: {
                            selectedPortion = portion
                            useCustomGrams = false
                        }) {
                            VStack(spacing: 4) {
                                Text(portion.displayName)
                                    .font(.system(size: 13, weight: .medium))
                                Text("\(Int(portion.weightInGrams))g")
                                    .font(.system(size: 11, weight: .regular))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                selectedPortion.name == portion.name && !useCustomGrams
                                    ? AppTheme.Colors.primary
                                    : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedPortion.name == portion.name && !useCustomGrams
                                    ? .white
                                    : .primary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }

            HStack(spacing: AppTheme.Spacing.sm) {
                Text("Custom:")
                    .font(.system(size: 14, weight: .medium))
                TextField("Grams", text: $customGrams)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
                Text("g")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                Toggle("", isOn: $useCustomGrams)
                    .labelsHidden()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    private var nutritionSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Nutrition for \(portionDescription)")
                .font(.system(size: 16, weight: .semibold))

            let nutrition = calculatedNutrition

            VStack(spacing: AppTheme.Spacing.sm) {
                NutrientRow(
                    label: "Calories",
                    value: nutrition.calories,
                    unit: "kcal",
                    color: AppTheme.Colors.calories,
                    icon: "flame.fill"
                )
                NutrientRow(
                    label: "Protein",
                    value: nutrition.protein,
                    unit: "g",
                    color: AppTheme.Colors.protein,
                    icon: "fish.fill"
                )
                NutrientRow(
                    label: "Carbs",
                    value: nutrition.carbs,
                    unit: "g",
                    color: AppTheme.Colors.carbs,
                    icon: "leaf.fill"
                )
                NutrientRow(
                    label: "Fats",
                    value: nutrition.fats,
                    unit: "g",
                    color: AppTheme.Colors.fats,
                    icon: "drop.fill"
                )
                NutrientRow(
                    label: "Fiber",
                    value: nutrition.fiber,
                    unit: "g",
                    color: AppTheme.Colors.fiber,
                    icon: "leaf.circle.fill"
                )
                NutrientRow(
                    label: "Sugar",
                    value: nutrition.sugar,
                    unit: "g",
                    color: AppTheme.Colors.sugar,
                    icon: "cube.fill"
                )
                NutrientRow(
                    label: "Sodium",
                    value: nutrition.sodium,
                    unit: "mg",
                    color: AppTheme.Colors.sodium,
                    icon: "sparkles"
                )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }

    private var selectButtonSection: some View {
        Button(action: {
            onSelect(food)
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Select This Food")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppTheme.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.md)
    }

    private var portionDescription: String {
        if useCustomGrams, let grams = Double(customGrams) {
            return "\(Int(grams))g"
        }
        return selectedPortion.displayName
    }

    private var calculatedNutrition: NutritionInfo {
        if useCustomGrams, let grams = Double(customGrams) {
            return IndianPortionMapping.calculateNutrition(for: food, grams: grams)
        }
        return IndianPortionMapping.calculateNutrition(for: food, portion: selectedPortion)
    }
}

struct NutrientRow: View {
    let label: String
    let value: Double
    let unit: String
    let color: Color
    let icon: String

    var body: some View {
        HStack {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 14))
                Text(label)
                    .font(.system(size: 15, weight: .medium))
            }
            Spacer()
            Text("\(String(format: "%.1f", value)) \(unit)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(color)
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    NutrientDetailSheet(
        food: IFCTFoodItem(
            code: "A001",
            name: "Rice, raw",
            localNames: "H. Chawal",
            group: "Cereals and Millets",
            energy: 345,
            protein: 6.8,
            fat: 0.5,
            carbs: 78.2,
            fiber: 0.6,
            sugar: 0.1,
            sodium: 5.0
        ),
        onSelect: { _ in }
    )
}
