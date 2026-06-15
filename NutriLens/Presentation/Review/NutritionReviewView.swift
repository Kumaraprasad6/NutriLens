import SwiftUI
import SwiftData

struct NutritionReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let foodItem: FoodItem
    var onDismiss: (() -> Void)?

    @State private var viewModel: NutritionReviewViewModel
    @State private var showSearchView = false

    init(foodItem: FoodItem, onDismiss: (() -> Void)? = nil) {
        self.foodItem = foodItem
        self.onDismiss = onDismiss
        self._viewModel = State(initialValue: NutritionReviewViewModel(foodItem: foodItem))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                foodImageSection

                nutritionSection

                actionButtons
            }
            .padding()
        }
        .background(AppTheme.Colors.groupedBackground)
        .navigationTitle("Review Food")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.isEditing ? "Done" : "Edit") {
                    if viewModel.isEditing {
                        viewModel.saveChanges()
                    } else {
                        viewModel.toggleEdit()
                    }
                }
            }
        }
        .alert("Error", isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onAppear {
            viewModel = NutritionReviewViewModel(
                foodItem: foodItem,
                modelContext: modelContext
            ) {
                onDismiss?()
                dismiss()
            }
        }
    }

    @ViewBuilder
    private var foodImageSection: some View {
        if let imageData = viewModel.foodItem.imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        } else {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                .fill(AppTheme.Colors.primary.opacity(0.1))
                .frame(height: 150)
                .overlay {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 50))
                        .foregroundStyle(AppTheme.Colors.primary)
                }
        }
    }

    private var nutritionSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            if viewModel.isEditing {
                editableNutritionForm
            } else {
                readOnlyNutritionDisplay
            }
        }
        .nutriCard()
    }

    private var readOnlyNutritionDisplay: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Text(viewModel.foodItem.name)
                .font(.title2)
                .fontWeight(.bold)

            Divider()

            VStack(spacing: AppTheme.Spacing.sm) {
                nutrientRow(icon: "flame.fill", label: "Calories", value: viewModel.foodItem.nutrition.calories, unit: "kcal", color: AppTheme.Colors.calories, progress: viewModel.foodItem.nutrition.calories / 2000)
                nutrientRow(icon: "fish.fill", label: "Protein", value: viewModel.foodItem.nutrition.protein, unit: "g", color: AppTheme.Colors.protein, progress: viewModel.foodItem.nutrition.protein / 50)
                nutrientRow(icon: "leaf.fill", label: "Carbs", value: viewModel.foodItem.nutrition.carbs, unit: "g", color: AppTheme.Colors.carbs, progress: viewModel.foodItem.nutrition.carbs / 250)
                nutrientRow(icon: "drop.fill", label: "Fats", value: viewModel.foodItem.nutrition.fats, unit: "g", color: AppTheme.Colors.fats, progress: viewModel.foodItem.nutrition.fats / 65)
                nutrientRow(icon: "leaf.circle.fill", label: "Fiber", value: viewModel.foodItem.nutrition.fiber, unit: "g", color: AppTheme.Colors.fiber, progress: viewModel.foodItem.nutrition.fiber / 30)
                nutrientRow(icon: "cube.fill", label: "Sugar", value: viewModel.foodItem.nutrition.sugar, unit: "g", color: AppTheme.Colors.sugar, progress: viewModel.foodItem.nutrition.sugar / 50)
                nutrientRow(icon: "sparkles", label: "Sodium", value: viewModel.foodItem.nutrition.sodium, unit: "mg", color: AppTheme.Colors.sodium, progress: viewModel.foodItem.nutrition.sodium / 2300)
            }
        }
    }

    private var editableNutritionForm: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            TextField("Food Name", text: $viewModel.editedName)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(.roundedBorder)

            Divider()

            editableNutrientField(label: "Calories", value: $viewModel.editedCalories, unit: "kcal")
            editableNutrientField(label: "Protein", value: $viewModel.editedProtein, unit: "g")
            editableNutrientField(label: "Carbs", value: $viewModel.editedCarbs, unit: "g")
            editableNutrientField(label: "Fats", value: $viewModel.editedFats, unit: "g")
            editableNutrientField(label: "Fiber", value: $viewModel.editedFiber, unit: "g")
            editableNutrientField(label: "Sugar", value: $viewModel.editedSugar, unit: "g")
            editableNutrientField(label: "Sodium", value: $viewModel.editedSodium, unit: "mg")
        }
    }

    private func editableNutrientField(label: String, value: Binding<String>, unit: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", text: value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)
                .textFieldStyle(.roundedBorder)
            Text(unit)
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
        }
    }

    private func nutrientRow(icon: String, label: String, value: Double, unit: String, color: Color, progress: Double) -> some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .frame(width: 24)
                Text(label)
                Spacer()
                Text("\(Int(value)) \(unit)")
                    .fontWeight(.medium)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.2))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * min(progress, 1.0), height: 6)
                }
            }
            .frame(height: 6)
        }
    }

    private var actionButtons: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Button {
                Task {
                    await viewModel.confirmAndSave()
                }
            } label: {
                HStack {
                    if viewModel.isSaving {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    Text("Confirm & Log")
                }
                .primaryButton()
            }
            .disabled(viewModel.isSaving)

            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .secondaryButton()
            }

            if viewModel.foodItem.confidence < 0.7 {
                Button {
                    showSearchView = true
                } label: {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search Alternative")
                    }
                    .foregroundColor(AppTheme.Colors.primary)
                    .padding(.vertical, AppTheme.Spacing.sm)
                }
            }
        }
        .sheet(isPresented: $showSearchView) {
            SearchView { food in
                let nutrition = food.nutritionForGrams(100)
                viewModel.foodItem = FoodItem(
                    name: food.name,
                    nutrition: nutrition,
                    imageData: viewModel.foodItem.imageData,
                    loggedAt: viewModel.foodItem.loggedAt,
                    mealType: viewModel.foodItem.mealType,
                    portion: viewModel.foodItem.portion,
                    confidence: 1.0,
                    source: .manualSearch,
                    foodCode: food.code
                )
                showSearchView = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        NutritionReviewView(
            foodItem: FoodItem(
                name: "Grilled Chicken Salad",
                nutrition: NutritionInfo(
                    calories: 450,
                    protein: 35,
                    carbs: 25,
                    fats: 20,
                    fiber: 8,
                    sugar: 10,
                    sodium: 800
                )
            )
        )
    }
    .modelContainer(for: [FoodEntryModel.self, NutritionGoalModel.self], inMemory: true)
}