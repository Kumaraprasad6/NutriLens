import XCTest
@testable import NutriLens

final class NutritionGoalTests: XCTestCase {
    func testNutritionGoalCreation() {
        let goal = NutritionGoal()

        XCTAssertEqual(goal.calories, NutritionConstants.defaultCalories)
        XCTAssertEqual(goal.protein, NutritionConstants.defaultProtein)
        XCTAssertEqual(goal.carbs, NutritionConstants.defaultCarbs)
        XCTAssertEqual(goal.fats, NutritionConstants.defaultFats)
    }

    func testNutritionGoalCustomValues() {
        let goal = NutritionGoal(
            calories: 2500,
            protein: 100,
            carbs: 300,
            fats: 80,
            fiber: 40,
            sugar: 60,
            sodium: 2500
        )

        XCTAssertEqual(goal.calories, 2500)
        XCTAssertEqual(goal.protein, 100)
        XCTAssertEqual(goal.carbs, 300)
        XCTAssertEqual(goal.fats, 80)
    }

    func testDefaultGoal() {
        let defaultGoal = NutritionGoal.defaultGoal

        XCTAssertEqual(defaultGoal.calories, 2000)
        XCTAssertEqual(defaultGoal.protein, 50)
        XCTAssertEqual(defaultGoal.carbs, 250)
        XCTAssertEqual(defaultGoal.fats, 65)
        XCTAssertEqual(defaultGoal.fiber, 30)
        XCTAssertEqual(defaultGoal.sugar, 50)
        XCTAssertEqual(defaultGoal.sodium, 2300)
    }
}