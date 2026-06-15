import XCTest
@testable import NutriLens

final class FoodItemTests: XCTestCase {
    func testFoodItemCreation() {
        let nutrition = NutritionInfo(
            calories: 500,
            protein: 30,
            carbs: 50,
            fats: 20,
            fiber: 10,
            sugar: 15,
            sodium: 800
        )
        let foodItem = FoodItem(name: "Test Food", nutrition: nutrition)

        XCTAssertEqual(foodItem.name, "Test Food")
        XCTAssertEqual(foodItem.nutrition.calories, 500)
        XCTAssertEqual(foodItem.nutrition.protein, 30)
        XCTAssertNotNil(foodItem.id)
        XCTAssertNotNil(foodItem.loggedAt)
        XCTAssertEqual(foodItem.mealType, MealType.from(time: foodItem.loggedAt))
        XCTAssertEqual(foodItem.portion, Portion.default)
        XCTAssertEqual(foodItem.confidence, 1.0)
        XCTAssertEqual(foodItem.source, .manualEntry)
        XCTAssertNil(foodItem.foodCode)
    }
    
    func testFoodItemCreationWithCustomFields() {
        let nutrition = NutritionInfo(
            calories: 500,
            protein: 30,
            carbs: 50,
            fats: 20,
            fiber: 10,
            sugar: 15,
            sodium: 800
        )
        let portion = Portion.grams(150)
        let foodItem = FoodItem(
            name: "Test Food",
            nutrition: nutrition,
            mealType: .lunch,
            portion: portion,
            confidence: 0.85,
            source: .camera,
            usdaFoodCode: "12345"
        )
        
        XCTAssertEqual(foodItem.mealType, .lunch)
        XCTAssertEqual(foodItem.portion, portion)
        XCTAssertEqual(foodItem.confidence, 0.85)
        XCTAssertEqual(foodItem.source, .camera)
        XCTAssertEqual(foodItem.usdaFoodCode, "12345")
    }

    func testFoodItemEquality() {
        let id = UUID()
        let nutrition = NutritionInfo(calories: 500, protein: 30, carbs: 50, fats: 20, fiber: 10, sugar: 15, sodium: 800)

        let item1 = FoodItem(id: id, name: "Test", nutrition: nutrition)
        let item2 = FoodItem(id: id, name: "Test", nutrition: nutrition)

        XCTAssertEqual(item1, item2)
    }

    func testNutritionInfoAddition() {
        let info1 = NutritionInfo(calories: 300, protein: 20, carbs: 30, fats: 10, fiber: 5, sugar: 10, sodium: 500)
        let info2 = NutritionInfo(calories: 200, protein: 10, carbs: 20, fats: 5, fiber: 3, sugar: 5, sodium: 300)

        let result = info1 + info2

        XCTAssertEqual(result.calories, 500)
        XCTAssertEqual(result.protein, 30)
        XCTAssertEqual(result.carbs, 50)
        XCTAssertEqual(result.fats, 15)
        XCTAssertEqual(result.fiber, 8)
        XCTAssertEqual(result.sugar, 15)
        XCTAssertEqual(result.sodium, 800)
    }

    func testNutritionInfoDefaultValues() {
        let info = NutritionInfo()

        XCTAssertEqual(info.calories, 0)
        XCTAssertEqual(info.protein, 0)
        XCTAssertEqual(info.carbs, 0)
        XCTAssertEqual(info.fats, 0)
        XCTAssertEqual(info.fiber, 0)
        XCTAssertEqual(info.sugar, 0)
        XCTAssertEqual(info.sodium, 0)
    }
    
    func testNutritionInfoCalculateForPortion() {
        let basePortion = Portion.grams(100)
        let nutrition = NutritionInfo(
            calories: 200,
            protein: 10,
            carbs: 25,
            fats: 8,
            fiber: 3,
            sugar: 5,
            sodium: 400,
            perServing: true,
            basePortion: basePortion
        )
        
        let newPortion = Portion.grams(150)
        let adjusted = nutrition.calculateFor(portion: newPortion)
        
        XCTAssertEqual(adjusted.calories, 300, accuracy: 0.01)
        XCTAssertEqual(adjusted.protein, 15, accuracy: 0.01)
        XCTAssertEqual(adjusted.carbs, 37.5, accuracy: 0.01)
        XCTAssertEqual(adjusted.fats, 12, accuracy: 0.01)
    }
    
    func testNutritionInfoCalculateForNonServing() {
        let nutrition = NutritionInfo(
            calories: 200,
            protein: 10,
            carbs: 25,
            fats: 8,
            fiber: 3,
            sugar: 5,
            sodium: 400,
            perServing: false
        )
        
        let newPortion = Portion.grams(150)
        let adjusted = nutrition.calculateFor(portion: newPortion)
        
        XCTAssertEqual(adjusted.calories, 200)
        XCTAssertEqual(adjusted.protein, 10)
    }
}