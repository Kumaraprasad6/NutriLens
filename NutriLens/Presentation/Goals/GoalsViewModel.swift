import Foundation
import SwiftData

@Observable
final class GoalsViewModel {
    var goals: NutritionGoal = .defaultGoal
    var isLoading = false
    var isSaving = false
    var errorMessage: String?
    var showSaveSuccess = false

    var caloriesText: String = ""
    var proteinText: String = ""
    var carbsText: String = ""
    var fatsText: String = ""
    var fiberText: String = ""
    var sugarText: String = ""
    var sodiumText: String = ""

    private let manageGoalsUseCase: ManageGoalsUseCase

    init(manageGoalsUseCase: ManageGoalsUseCase? = nil) {
        let context = Self.createDefaultContext()
        let repository = GoalsRepository(modelContext: context)
        self.manageGoalsUseCase = manageGoalsUseCase ?? ManageGoalsUseCase(repository: repository)
    }
    
    private static func createDefaultContext() -> ModelContext {
        do {
            let schema = Schema([NutritionGoalModel.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
            return ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            do {
                let schema = Schema([NutritionGoalModel.self])
                let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
                return ModelContext(container)
            } catch {
                fatalError("Could not create any ModelContainer: \(error)")
            }
        }
    }

    init(modelContext: ModelContext, manageGoalsUseCase: ManageGoalsUseCase? = nil) {
        let repository = GoalsRepository(modelContext: modelContext)
        self.manageGoalsUseCase = manageGoalsUseCase ?? ManageGoalsUseCase(repository: repository)
    }

    func loadGoals() async {
        isLoading = true
        do {
            goals = try await manageGoalsUseCase.getGoals()
            updateTextFields()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func saveGoals() async {
        guard let calories = Double(caloriesText),
              let protein = Double(proteinText),
              let carbs = Double(carbsText),
              let fats = Double(fatsText),
              let fiber = Double(fiberText),
              let sugar = Double(sugarText),
              let sodium = Double(sodiumText) else {
            errorMessage = "Please enter valid numbers for all fields"
            return
        }

        let newGoals = NutritionGoal(
            id: goals.id,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            fiber: fiber,
            sugar: sugar,
            sodium: sodium,
            createdAt: goals.createdAt,
            updatedAt: .now
        )

        let validationErrors = manageGoalsUseCase.validateGoals(newGoals)
        if !validationErrors.isEmpty {
            errorMessage = validationErrors.first?.localizedDescription
            return
        }

        isSaving = true
        do {
            try await manageGoalsUseCase.saveGoals(newGoals)
            goals = newGoals
            showSaveSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }

    func resetToDefaults() {
        goals = .defaultGoal
        updateTextFields()
    }

    private func updateTextFields() {
        caloriesText = String(format: "%.0f", goals.calories)
        proteinText = String(format: "%.0f", goals.protein)
        carbsText = String(format: "%.0f", goals.carbs)
        fatsText = String(format: "%.0f", goals.fats)
        fiberText = String(format: "%.0f", goals.fiber)
        sugarText = String(format: "%.0f", goals.sugar)
        sodiumText = String(format: "%.0f", goals.sodium)
    }
}