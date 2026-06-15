import Foundation

struct DailySummary: Equatable {
    let date: Date
    let entries: [FoodItem]
    let totalNutrition: NutritionInfo
    let goal: NutritionGoal
    let progress: NutritionProgress
    let mealTypeTotals: [MealType: NutritionInfo]
    let totalPortions: Int
}

struct NutritionProgress: Equatable {
    let calorieProgress: Double
    let proteinProgress: Double
    let carbsProgress: Double
    let fatsProgress: Double
    let fiberProgress: Double
    let sugarProgress: Double
    let sodiumProgress: Double

    static var zero: NutritionProgress {
        NutritionProgress(
            calorieProgress: 0,
            proteinProgress: 0,
            carbsProgress: 0,
            fatsProgress: 0,
            fiberProgress: 0,
            sugarProgress: 0,
            sodiumProgress: 0
        )
    }
}

final class GetDailySummaryUseCase {
    private let foodRepository: FoodRepositoryProtocol
    private let goalsRepository: GoalsRepositoryProtocol

    init(foodRepository: FoodRepositoryProtocol, goalsRepository: GoalsRepositoryProtocol) {
        self.foodRepository = foodRepository
        self.goalsRepository = goalsRepository
    }

    func execute(for date: Date = .now) async throws -> DailySummary {
        let entries = try await foodRepository.fetchEntries(for: date)
        let goals = try await goalsRepository.getGoals()
        let totalNutrition = calculateTotalNutrition(from: entries)
        let progress = calculateProgress(actual: totalNutrition, goal: goals)
        let mealTypeTotals = calculateMealTypeTotals(from: entries)
        let totalPortions = entries.count

        return DailySummary(
            date: date,
            entries: entries,
            totalNutrition: totalNutrition,
            goal: goals,
            progress: progress,
            mealTypeTotals: mealTypeTotals,
            totalPortions: totalPortions
        )
    }

    private func calculateTotalNutrition(from entries: [FoodItem]) -> NutritionInfo {
        entries.reduce(NutritionInfo()) { result, entry in
            result + entry.nutrition
        }
    }
    
    private func calculateMealTypeTotals(from entries: [FoodItem]) -> [MealType: NutritionInfo] {
        var totals: [MealType: NutritionInfo] = [:]
        
        for entry in entries {
            let current = totals[entry.mealType] ?? NutritionInfo()
            totals[entry.mealType] = current + entry.nutrition
        }
        
        return totals
    }

    private func calculateProgress(actual: NutritionInfo, goal: NutritionGoal) -> NutritionProgress {
        NutritionProgress(
            calorieProgress: min(actual.calories / goal.calories, 1.5),
            proteinProgress: min(actual.protein / goal.protein, 1.5),
            carbsProgress: min(actual.carbs / goal.carbs, 1.5),
            fatsProgress: min(actual.fats / goal.fats, 1.5),
            fiberProgress: min(actual.fiber / goal.fiber, 1.5),
            sugarProgress: min(actual.sugar / goal.sugar, 1.5),
            sodiumProgress: min(actual.sodium / goal.sodium, 1.5)
        )
    }
}