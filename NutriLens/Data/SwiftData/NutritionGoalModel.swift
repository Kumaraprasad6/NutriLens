import Foundation
import SwiftData

@Model
final class NutritionGoalModel {
    @Attribute(.unique) var id: UUID
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var fiber: Double
    var sugar: Double
    var sodium: Double
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        calories: Double = NutritionConstants.defaultCalories,
        protein: Double = NutritionConstants.defaultProtein,
        carbs: Double = NutritionConstants.defaultCarbs,
        fats: Double = NutritionConstants.defaultFats,
        fiber: Double = NutritionConstants.defaultFiber,
        sugar: Double = NutritionConstants.defaultSugar,
        sodium: Double = NutritionConstants.defaultSodium,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension NutritionGoalModel {
    static func from(entity: NutritionGoal) -> NutritionGoalModel {
        NutritionGoalModel(
            id: entity.id,
            calories: entity.calories,
            protein: entity.protein,
            carbs: entity.carbs,
            fats: entity.fats,
            fiber: entity.fiber,
            sugar: entity.sugar,
            sodium: entity.sodium,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }

    func toEntity() -> NutritionGoal {
        NutritionGoal(
            id: id,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            fiber: fiber,
            sugar: sugar,
            sodium: sodium,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}