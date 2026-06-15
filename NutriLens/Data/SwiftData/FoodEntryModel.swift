import Foundation
import SwiftData

@Model
final class FoodEntryModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var fiber: Double
    var sugar: Double
    var sodium: Double
    @Attribute(.externalStorage) var imageData: Data?
    var loggedAt: Date
    var mealType: String
    var portionAmount: Double
    var portionUnit: String
    var portionDescription: String
    var confidence: Double
    var source: String
    var foodCode: String?

    init(
        id: UUID = UUID(),
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fats: Double,
        fiber: Double,
        sugar: Double,
        sodium: Double,
        imageData: Data? = nil,
        loggedAt: Date = .now,
        mealType: String = MealType.breakfast.rawValue,
        portionAmount: Double = 1.0,
        portionUnit: String = "serving",
        portionDescription: String = "",
        confidence: Double = 1.0,
        source: String = FoodSource.manualEntry.rawValue,
        foodCode: String? = nil
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.imageData = imageData
        self.loggedAt = loggedAt
        self.mealType = mealType
        self.portionAmount = portionAmount
        self.portionUnit = portionUnit
        self.portionDescription = portionDescription
        self.confidence = confidence
        self.source = source
        self.foodCode = foodCode
    }
}

extension FoodEntryModel {
    static func from(entity: FoodItem) -> FoodEntryModel {
        FoodEntryModel(
            id: entity.id,
            name: entity.name,
            calories: entity.nutrition.calories,
            protein: entity.nutrition.protein,
            carbs: entity.nutrition.carbs,
            fats: entity.nutrition.fats,
            fiber: entity.nutrition.fiber,
            sugar: entity.nutrition.sugar,
            sodium: entity.nutrition.sodium,
            imageData: entity.imageData,
            loggedAt: entity.loggedAt,
            mealType: entity.mealType.rawValue,
            portionAmount: entity.portion.amount,
            portionUnit: entity.portion.unit,
            portionDescription: entity.portion.description,
            confidence: entity.confidence,
            source: entity.source.rawValue,
            foodCode: entity.foodCode
        )
    }

    func toEntity() -> FoodItem {
        FoodItem(
            id: id,
            name: name,
            nutrition: NutritionInfo(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                fiber: fiber,
                sugar: sugar,
                sodium: sodium
            ),
            imageData: imageData,
            loggedAt: loggedAt,
            mealType: MealType(rawValue: mealType) ?? .snack,
            portion: Portion(
                amount: portionAmount,
                unit: portionUnit,
                description: portionDescription
            ),
            confidence: confidence,
            source: FoodSource(rawValue: source) ?? .manualEntry,
            foodCode: foodCode
        )
    }
}