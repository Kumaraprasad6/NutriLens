import SwiftUI

struct ManualEntryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var carbs: String = ""
    @State private var fats: String = ""
    @State private var fiber: String = ""
    @State private var sugar: String = ""
    @State private var sodium: String = ""

    @State private var showValidationError = false
    @State private var validationMessage = ""
    @State private var showSearchView = false

    let onSubmit: (String, Double, Double, Double, Double, Double, Double, Double) -> Void

    var body: some View {
        Form {
            Section {
                TextField("Food Name", text: $name)
                    .textContentType(.none)
                    .autocorrectionDisabled()
            } header: {
                Text("Food Name")
            }

            Section {
                nutrientField(label: "Calories", value: $calories, unit: "kcal", icon: "flame.fill", color: AppTheme.Colors.calories)
                nutrientField(label: "Protein", value: $protein, unit: "g", icon: "fish.fill", color: AppTheme.Colors.protein)
                nutrientField(label: "Carbs", value: $carbs, unit: "g", icon: "leaf.fill", color: AppTheme.Colors.carbs)
                nutrientField(label: "Fats", value: $fats, unit: "g", icon: "drop.fill", color: AppTheme.Colors.fats)
            } header: {
                Text("Macronutrients")
            }

            Section {
                nutrientField(label: "Fiber", value: $fiber, unit: "g", icon: "leaf.circle.fill", color: AppTheme.Colors.fiber)
                nutrientField(label: "Sugar", value: $sugar, unit: "g", icon: "cube.fill", color: AppTheme.Colors.sugar)
                nutrientField(label: "Sodium", value: $sodium, unit: "mg", icon: "sparkles", color: AppTheme.Colors.sodium)
            } header: {
                Text("Micronutrients")
            }

            Section {
                quickAddButtons
            } header: {
                Text("Quick Add")
            }

            Section {
                Button {
                    showSearchView = true
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppTheme.Colors.primary)
                        Text("Search Indian Food")
                            .foregroundColor(AppTheme.Colors.primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Manual Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    submitEntry()
                }
                .fontWeight(.semibold)
                .disabled(!isValid)
            }
        }
        .alert("Validation Error", isPresented: $showValidationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(validationMessage)
        }
        .sheet(isPresented: $showSearchView) {
            SearchView { food in
                name = food.name
                let nutrition = food.nutritionForGrams(100)
                calories = String(format: "%.0f", nutrition.calories)
                protein = String(format: "%.1f", nutrition.protein)
                carbs = String(format: "%.1f", nutrition.carbs)
                fats = String(format: "%.1f", nutrition.fats)
                fiber = String(format: "%.1f", nutrition.fiber)
                sugar = String(format: "%.1f", nutrition.sugar)
                sodium = String(format: "%.0f", nutrition.sodium)
            }
        }
    }

    private func nutrientField(
        label: String,
        value: Binding<String>,
        unit: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(label)

            Spacer()

            TextField("0", text: value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)

            Text(unit)
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
        }
    }

    private var quickAddButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                quickAddButton("Apple", calories: 95, protein: 0.5, carbs: 25, fats: 0.3, fiber: 4.4, sugar: 19, sodium: 2)
                quickAddButton("Banana", calories: 105, protein: 1.3, carbs: 27, fats: 0.4, fiber: 3.1, sugar: 14, sodium: 1)
                quickAddButton("Egg", calories: 78, protein: 6, carbs: 0.6, fats: 5, fiber: 0, sugar: 0.6, sodium: 62)
                quickAddButton("Chicken", calories: 165, protein: 31, carbs: 0, fats: 3.6, fiber: 0, sugar: 0, sodium: 74)
                quickAddButton("Rice", calories: 206, protein: 4.3, carbs: 45, fats: 0.4, fiber: 0.6, sugar: 0.1, sodium: 1.6)
            }
            .padding(.vertical, AppTheme.Spacing.xs)
        }
    }

    private func quickAddButton(
        _ foodName: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fats: Double,
        fiber: Double,
        sugar: Double,
        sodium: Double
    ) -> some View {
        Button {
            name = foodName
            self.calories = String(format: "%.0f", calories)
            self.protein = String(format: "%.1f", protein)
            self.carbs = String(format: "%.1f", carbs)
            self.fats = String(format: "%.1f", fats)
            self.fiber = String(format: "%.1f", fiber)
            self.sugar = String(format: "%.1f", sugar)
            self.sodium = String(format: "%.0f", sodium)
        } label: {
            Text(foodName)
                .font(.subheadline)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.primary.opacity(0.1))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        Double(calories) != nil &&
        Double(protein) != nil &&
        Double(carbs) != nil &&
        Double(fats) != nil
    }

    private func submitEntry() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            validationMessage = "Please enter a food name"
            showValidationError = true
            return
        }

        let parsedCalories = Double(calories) ?? 0
        let parsedProtein = Double(protein) ?? 0
        let parsedCarbs = Double(carbs) ?? 0
        let parsedFats = Double(fats) ?? 0
        let parsedFiber = Double(fiber) ?? 0
        let parsedSugar = Double(sugar) ?? 0
        let parsedSodium = Double(sodium) ?? 0

        onSubmit(
            name.trimmingCharacters(in: .whitespaces),
            parsedCalories,
            parsedProtein,
            parsedCarbs,
            parsedFats,
            parsedFiber,
            parsedSugar,
            parsedSodium
        )
        dismiss()
    }
}

#Preview {
    NavigationStack {
        ManualEntryView { _, _, _, _, _, _, _, _ in }
    }
}