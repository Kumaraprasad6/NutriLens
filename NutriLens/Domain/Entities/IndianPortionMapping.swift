import Foundation

struct IndianPortion: Equatable, Codable {
    let name: String
    let displayName: String
    let weightInGrams: Double
    let description: String
    let baseIngredientCode: String
    let yieldFactor: Double

    static func == (lhs: IndianPortion, rhs: IndianPortion) -> Bool {
        lhs.name == rhs.name && lhs.weightInGrams == rhs.weightInGrams
    }
}

enum IndianPortionMapping {
    static let allPortions: [IndianPortion] = [
        IndianPortionMapping.roti,
        IndianPortionMapping.katoriDal,
        IndianPortionMapping.idli,
        IndianPortionMapping.dosa,
        IndianPortionMapping.chapati,
        IndianPortionMapping.bowlRice,
        IndianPortionMapping.paratha,
        IndianPortionMapping.cupTea
    ]

    static let roti = IndianPortion(
        name: "roti",
        displayName: "1 Roti (Medium)",
        weightInGrams: 30,
        description: "Medium roti made from 30g atta",
        baseIngredientCode: "A005",
        yieldFactor: 1.0
    )

    static let katoriDal = IndianPortion(
        name: "katori_dal",
        displayName: "1 Katori Dal",
        weightInGrams: 150,
        description: "150g cooked dal (lentil curry)",
        baseIngredientCode: "B001",
        yieldFactor: 2.5
    )

    static let idli = IndianPortion(
        name: "idli",
        displayName: "1 Idli",
        weightInGrams: 75,
        description: "75g raw idli batter",
        baseIngredientCode: "A033",
        yieldFactor: 1.0
    )

    static let dosa = IndianPortion(
        name: "dosa",
        displayName: "1 Dosa (Medium)",
        weightInGrams: 100,
        description: "100g dosa batter",
        baseIngredientCode: "A033",
        yieldFactor: 1.0
    )

    static let chapati = IndianPortion(
        name: "chapati",
        displayName: "1 Chapati",
        weightInGrams: 25,
        description: "25g wheat flour",
        baseIngredientCode: "A005",
        yieldFactor: 1.0
    )

    static let bowlRice = IndianPortion(
        name: "bowl_rice",
        displayName: "1 Bowl Rice",
        weightInGrams: 150,
        description: "150g cooked rice",
        baseIngredientCode: "A011",
        yieldFactor: 2.5
    )

    static let paratha = IndianPortion(
        name: "paratha",
        displayName: "1 Paratha",
        weightInGrams: 50,
        description: "40g atta + 10g oil",
        baseIngredientCode: "A005",
        yieldFactor: 1.0
    )

    static let cupTea = IndianPortion(
        name: "cup_tea",
        displayName: "1 Cup Tea",
        weightInGrams: 215,
        description: "200ml milk + 10g sugar + 5ml milk",
        baseIngredientCode: "D001",
        yieldFactor: 1.0
    )

    static func portion(for name: String) -> IndianPortion? {
        allPortions.first { $0.name == name || $0.displayName == name }
    }

    static func calculateNutrition(
        for food: IFCTFoodItem,
        portion: IndianPortion
    ) -> NutritionInfo {
        let scale = portion.weightInGrams / 100.0
        return NutritionInfo(
            calories: food.energy * scale,
            protein: food.protein * scale,
            carbs: food.carbs * scale,
            fats: food.fat * scale,
            fiber: food.fiber * scale,
            sugar: food.sugar * scale,
            sodium: food.sodium * scale,
            perServing: true,
            basePortion: .grams(100)
        )
    }

    static func calculateNutrition(
        for food: IFCTFoodItem,
        grams: Double
    ) -> NutritionInfo {
        let scale = grams / 100.0
        return NutritionInfo(
            calories: food.energy * scale,
            protein: food.protein * scale,
            carbs: food.carbs * scale,
            fats: food.fat * scale,
            fiber: food.fiber * scale,
            sugar: food.sugar * scale,
            sodium: food.sodium * scale,
            perServing: true,
            basePortion: .grams(100)
        )
    }
}
