import Foundation

struct FoodItem: Identifiable, Equatable {
    let id: UUID
    var name: String
    var nutrition: NutritionInfo
    var imageData: Data?
    var loggedAt: Date
    var mealType: MealType
    var portion: Portion
    var confidence: Double
    var source: FoodSource
    var foodCode: String?

    init(
        id: UUID = UUID(),
        name: String,
        nutrition: NutritionInfo,
        imageData: Data? = nil,
        loggedAt: Date = .now,
        mealType: MealType? = nil,
        portion: Portion = .default,
        confidence: Double = 1.0,
        source: FoodSource = .manualEntry,
        foodCode: String? = nil
    ) {
        self.id = id
        self.name = name
        self.nutrition = nutrition
        self.imageData = imageData
        self.loggedAt = loggedAt
        self.mealType = mealType ?? MealType.from(time: loggedAt)
        self.portion = portion
        self.confidence = confidence
        self.source = source
        self.foodCode = foodCode
    }
}

struct NutritionInfo: Equatable {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fats: Double
    var fiber: Double
    var sugar: Double
    var sodium: Double
    var perServing: Bool
    var basePortion: Portion

    init(
        calories: Double = 0,
        protein: Double = 0,
        carbs: Double = 0,
        fats: Double = 0,
        fiber: Double = 0,
        sugar: Double = 0,
        sodium: Double = 0,
        perServing: Bool = false,
        basePortion: Portion = .default
    ) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.perServing = perServing
        self.basePortion = basePortion
    }

    static func + (lhs: NutritionInfo, rhs: NutritionInfo) -> NutritionInfo {
        NutritionInfo(
            calories: lhs.calories + rhs.calories,
            protein: lhs.protein + rhs.protein,
            carbs: lhs.carbs + rhs.carbs,
            fats: lhs.fats + rhs.fats,
            fiber: lhs.fiber + rhs.fiber,
            sugar: lhs.sugar + rhs.sugar,
            sodium: lhs.sodium + rhs.sodium
        )
    }
    
    func calculateFor(portion: Portion) -> NutritionInfo {
        guard perServing && basePortion.amount > 0 else {
            return self
        }
        
        let ratio = portion.amount / basePortion.amount
        
        return NutritionInfo(
            calories: calories * ratio,
            protein: protein * ratio,
            carbs: carbs * ratio,
            fats: fats * ratio,
            fiber: fiber * ratio,
            sugar: sugar * ratio,
            sodium: sodium * ratio
        )
    }
    
    mutating func apply(portion: Portion) {
        let adjusted = calculateFor(portion: portion)
        self = adjusted
    }
}

struct NutritionGoal: Identifiable, Equatable {
    let id: UUID
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

    static var defaultGoal: NutritionGoal {
        NutritionGoal()
    }
}
