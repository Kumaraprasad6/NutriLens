import Foundation

protocol FoodRepositoryProtocol {
    func save(_ entry: FoodItem) async throws
    func fetchEntries(for date: Date) async throws -> [FoodItem]
    func fetchEntries(from startDate: Date, to endDate: Date) async throws -> [FoodItem]
    func fetchByMealType(_ mealType: MealType, for date: Date) async throws -> [FoodItem]
    func fetchByDateRange(start: Date, end: Date) async throws -> [FoodItem]
    func delete(_ entry: FoodItem) async throws
    func update(_ entry: FoodItem) async throws
}

protocol GoalsRepositoryProtocol {
    func getGoals() async throws -> NutritionGoal
    func saveGoals(_ goals: NutritionGoal) async throws
}

protocol NutritionParsingServiceProtocol {
    func parseFood(from imageData: Data) async throws -> FoodItem
    func generateSampleNutrition(for name: String) -> NutritionInfo
}