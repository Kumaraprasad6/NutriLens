import Foundation

struct WeeklyTrend: Equatable {
    let date: Date
    let totalCalories: Double
    let totalProtein: Double
    let totalCarbs: Double
    let totalFats: Double
}

struct WeeklyData: Equatable {
    let startDate: Date
    let endDate: Date
    let trends: [WeeklyTrend]
    let averageCalories: Double
    let totalEntries: Int
}

final class GetWeeklyTrendsUseCase {
    private let repository: FoodRepositoryProtocol

    init(repository: FoodRepositoryProtocol) {
        self.repository = repository
    }

    func execute(forWeekContaining date: Date = .now) async throws -> WeeklyData {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)

        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)),
              let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else {
            throw TrendError.invalidDateRange
        }

        let entries = try await repository.fetchEntries(from: weekStart, to: weekEnd)
        let groupedByDay = Dictionary(grouping: entries) { entry in
            calendar.startOfDay(for: entry.loggedAt)
        }

        var trends: [WeeklyTrend] = []
        for dayOffset in 0..<7 {
            guard let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { continue }
            let dayEntries = groupedByDay[dayDate] ?? []
            let totals = dayEntries.reduce(NutritionInfo()) { $0 + $1.nutrition }

            trends.append(WeeklyTrend(
                date: dayDate,
                totalCalories: totals.calories,
                totalProtein: totals.protein,
                totalCarbs: totals.carbs,
                totalFats: totals.fats
            ))
        }

        let totalCalories = trends.reduce(0) { $0 + $1.totalCalories }
        let averageCalories = trends.isEmpty ? 0 : totalCalories / Double(trends.count)

        return WeeklyData(
            startDate: weekStart,
            endDate: weekEnd,
            trends: trends,
            averageCalories: averageCalories,
            totalEntries: entries.count
        )
    }

    func executeMonthly(forMonthContaining date: Date = .now) async throws -> WeeklyData {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)

        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today)),
              let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart) else {
            throw TrendError.invalidDateRange
        }

        let entries = try await repository.fetchEntries(from: monthStart, to: monthEnd)
        let groupedByWeek = Dictionary(grouping: entries) { entry in
            calendar.component(.weekOfYear, from: entry.loggedAt)
        }

        let weekNumbers = groupedByWeek.keys.sorted()
        var trends: [WeeklyTrend] = []

        for weekNumber in weekNumbers {
            guard let weekEntries = groupedByWeek[weekNumber] else { continue }
            let totals = weekEntries.reduce(NutritionInfo()) { $0 + $1.nutrition }
            let firstEntryOfWeek = weekEntries.first!
            let weekStart = calendar.startOfDay(for: firstEntryOfWeek.loggedAt)

            trends.append(WeeklyTrend(
                date: weekStart,
                totalCalories: totals.calories,
                totalProtein: totals.protein,
                totalCarbs: totals.carbs,
                totalFats: totals.fats
            ))
        }

        let totalCalories = trends.reduce(0) { $0 + $1.totalCalories }
        let averageCalories = trends.isEmpty ? 0 : totalCalories / Double(trends.count)

        return WeeklyData(
            startDate: monthStart,
            endDate: monthEnd,
            trends: trends,
            averageCalories: averageCalories,
            totalEntries: entries.count
        )
    }
}

enum TrendError: Error, LocalizedError {
    case invalidDateRange

    var errorDescription: String? {
        switch self {
        case .invalidDateRange:
            return "Invalid date range for trend calculation"
        }
    }
}