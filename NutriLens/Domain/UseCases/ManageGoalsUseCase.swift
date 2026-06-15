import Foundation

final class ManageGoalsUseCase {
    private let repository: GoalsRepositoryProtocol

    init(repository: GoalsRepositoryProtocol) {
        self.repository = repository
    }

    func getGoals() async throws -> NutritionGoal {
        try await repository.getGoals()
    }

    func saveGoals(_ goals: NutritionGoal) async throws {
        var updatedGoals = goals
        updatedGoals = NutritionGoal(
            id: goals.id,
            calories: goals.calories,
            protein: goals.protein,
            carbs: goals.carbs,
            fats: goals.fats,
            fiber: goals.fiber,
            sugar: goals.sugar,
            sodium: goals.sodium,
            createdAt: goals.createdAt,
            updatedAt: .now
        )
        try await repository.saveGoals(updatedGoals)
    }

    func validateGoals(_ goals: NutritionGoal) -> [GoalValidationError] {
        var errors: [GoalValidationError] = []

        if goals.calories <= 0 {
            errors.append(.invalidCalories)
        }
        if goals.calories > 10000 {
            errors.append(.caloriesTooHigh)
        }
        if goals.protein < 0 {
            errors.append(.negativeProtein)
        }
        if goals.carbs < 0 {
            errors.append(.negativeCarbs)
        }
        if goals.fats < 0 {
            errors.append(.negativeFats)
        }
        if goals.fiber < 0 {
            errors.append(.negativeFiber)
        }
        if goals.sugar < 0 {
            errors.append(.negativeSugar)
        }
        if goals.sodium < 0 {
            errors.append(.negativeSodium)
        }

        return errors
    }
}

enum GoalValidationError: Error, LocalizedError {
    case invalidCalories
    case caloriesTooHigh
    case negativeProtein
    case negativeCarbs
    case negativeFats
    case negativeFiber
    case negativeSugar
    case negativeSodium

    var errorDescription: String? {
        switch self {
        case .invalidCalories:
            return "Calories must be greater than 0"
        case .caloriesTooHigh:
            return "Calories seem too high (max 10,000)"
        case .negativeProtein:
            return "Protein cannot be negative"
        case .negativeCarbs:
            return "Carbs cannot be negative"
        case .negativeFats:
            return "Fats cannot be negative"
        case .negativeFiber:
            return "Fiber cannot be negative"
        case .negativeSugar:
            return "Sugar cannot be negative"
        case .negativeSodium:
            return "Sodium cannot be negative"
        }
    }
}