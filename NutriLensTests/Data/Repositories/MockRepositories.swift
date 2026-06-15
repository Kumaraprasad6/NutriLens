import Foundation
@testable import NutriLens

final class MockFoodRepository: FoodRepositoryProtocol {
    var saveCalled = false
    var deleteCalled = false
    var updateCalled = false
    var fetchEntriesResult: [FoodItem] = []
    var savedEntry: FoodItem?

    func save(_ entry: FoodItem) async throws {
        saveCalled = true
        savedEntry = entry
    }

    func fetchEntries(for date: Date) async throws -> [FoodItem] {
        fetchEntriesResult
    }

    func fetchEntries(from startDate: Date, to endDate: Date) async throws -> [FoodItem] {
        fetchEntriesResult
    }

    func fetchByMealType(_ mealType: MealType, for date: Date) async throws -> [FoodItem] {
        fetchEntriesResult.filter { $0.mealType == mealType }
    }

    func fetchByDateRange(start: Date, end: Date) async throws -> [FoodItem] {
        fetchEntriesResult
    }

    func delete(_ entry: FoodItem) async throws {
        deleteCalled = true
    }

    func update(_ entry: FoodItem) async throws {
        updateCalled = true
    }
}

final class MockGoalsRepository: GoalsRepositoryProtocol {
    var saveGoalsCalled = false
    var getGoalsCalled = false

    func getGoals() async throws -> NutritionGoal {
        getGoalsCalled = true
        return .defaultGoal
    }

    func saveGoals(_ goals: NutritionGoal) async throws {
        saveGoalsCalled = true
    }
}

final class MockParsingService: NutritionParsingServiceProtocol {
    var parseFoodCalled = false
    var parseFoodResult: FoodItem?

    func parseFood(from imageData: Data) async throws -> FoodItem {
        parseFoodCalled = true
        return parseFoodResult ?? FoodItem(
            name: "Mock Food",
            nutrition: NutritionInfo(calories: 500, protein: 30, carbs: 50, fats: 20, fiber: 10, sugar: 15, sodium: 800)
        )
    }

    func generateSampleNutrition(for name: String) -> NutritionInfo {
        NutritionInfo(calories: 500, protein: 30, carbs: 50, fats: 20, fiber: 10, sugar: 15, sodium: 800)
    }
}