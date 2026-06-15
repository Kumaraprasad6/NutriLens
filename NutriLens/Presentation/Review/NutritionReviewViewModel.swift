import Foundation

@Observable
final class NutritionReviewViewModel {
    var foodItem: FoodItem
    var isEditing = false
    var isSaving = false
    var errorMessage: String?
    var aiPredictions: [FoodRecognitionResult] = []

    var editedName: String
    var editedCalories: String
    var editedProtein: String
    var editedCarbs: String
    var editedFats: String
    var editedFiber: String
    var editedSugar: String
    var editedSodium: String

    private let logFoodUseCase: LogFoodUseCase
    var onSave: (() -> Void)?

    init(foodItem: FoodItem, aiPredictions: [FoodRecognitionResult] = [], logFoodUseCase: LogFoodUseCase? = nil) {
        let context = Self.createDefaultContext()
        let repository = FoodRepository(modelContext: context)
        let useCase = logFoodUseCase ?? LogFoodUseCase(repository: repository)
        self.foodItem = foodItem
        self.aiPredictions = aiPredictions
        self.logFoodUseCase = useCase

        self.editedName = foodItem.name
        self.editedCalories = String(format: "%.0f", foodItem.nutrition.calories)
        self.editedProtein = String(format: "%.1f", foodItem.nutrition.protein)
        self.editedCarbs = String(format: "%.1f", foodItem.nutrition.carbs)
        self.editedFats = String(format: "%.1f", foodItem.nutrition.fats)
        self.editedFiber = String(format: "%.1f", foodItem.nutrition.fiber)
        self.editedSugar = String(format: "%.1f", foodItem.nutrition.sugar)
        self.editedSodium = String(format: "%.0f", foodItem.nutrition.sodium)
    }

    func applyPrediction(_ prediction: FoodRecognitionResult) {
        guard let nutrition = prediction.mappedNutrition else { return }
        foodItem.name = prediction.mappedFoodItem?.displayName ?? prediction.foodName
        foodItem.nutrition = nutrition
        foodItem.confidence = prediction.confidence
        foodItem.foodCode = prediction.mappedFoodItem?.code

        editedName = foodItem.name
        editedCalories = String(format: "%.0f", foodItem.nutrition.calories)
        editedProtein = String(format: "%.1f", foodItem.nutrition.protein)
        editedCarbs = String(format: "%.1f", foodItem.nutrition.carbs)
        editedFats = String(format: "%.1f", foodItem.nutrition.fats)
        editedFiber = String(format: "%.1f", foodItem.nutrition.fiber)
        editedSugar = String(format: "%.1f", foodItem.nutrition.sugar)
        editedSodium = String(format: "%.0f", foodItem.nutrition.sodium)
    }

    private static func createDefaultContext() -> ModelContext {
        do {
            let schema = Schema([FoodEntryModel.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
            return ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            do {
                let schema = Schema([FoodEntryModel.self])
                let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
                return ModelContext(container)
            } catch {
                fatalError("Could not create any ModelContainer: \(error)")
            }
        }
    }

    func toggleEdit() {
        isEditing.toggle()
        if !isEditing {
            resetEdits()
        }
    }

    func resetEdits() {
        editedName = foodItem.name
        editedCalories = String(format: "%.0f", foodItem.nutrition.calories)
        editedProtein = String(format: "%.1f", foodItem.nutrition.protein)
        editedCarbs = String(format: "%.1f", foodItem.nutrition.carbs)
        editedFats = String(format: "%.1f", foodItem.nutrition.fats)
        editedFiber = String(format: "%.1f", foodItem.nutrition.fiber)
        editedSugar = String(format: "%.1f", foodItem.nutrition.sugar)
        editedSodium = String(format: "%.0f", foodItem.nutrition.sodium)
    }

    func saveChanges() {
        guard let calories = Double(editedCalories),
              let protein = Double(editedProtein),
              let carbs = Double(editedCarbs),
              let fats = Double(editedFats),
              let fiber = Double(editedFiber),
              let sugar = Double(editedSugar),
              let sodium = Double(editedSodium) else {
            errorMessage = "Please enter valid numbers for all fields"
            return
        }

        foodItem.name = editedName
        foodItem.nutrition = NutritionInfo(
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            fiber: fiber,
            sugar: sugar,
            sodium: sodium
        )
        isEditing = false
    }

    func confirmAndSave() async {
        isSaving = true
        errorMessage = nil

        do {
            try await logFoodUseCase.execute(foodItem)
            await MainActor.run {
                isSaving = false
                onSave?()
            }
        } catch {
            await MainActor.run {
                isSaving = false
                errorMessage = error.localizedDescription
            }
        }
    }
}

import SwiftData

extension NutritionReviewViewModel {
    convenience init(
        foodItem: FoodItem,
        aiPredictions: [FoodRecognitionResult] = [],
        modelContext: ModelContext,
        onSave: (() -> Void)? = nil
    ) {
        let repository = FoodRepository(modelContext: modelContext)
        let useCase = LogFoodUseCase(repository: repository)
        self.init(foodItem: foodItem, aiPredictions: aiPredictions, logFoodUseCase: useCase)
        self.onSave = onSave
    }
}