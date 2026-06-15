import Foundation
import SwiftData

final class FoodRepository: FoodRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ entry: FoodItem) async throws {
        let model = FoodEntryModel.from(entity: entry)
        modelContext.insert(model)
        try modelContext.save()
    }

    func fetchEntries(for date: Date) async throws -> [FoodItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<FoodEntryModel> { model in
            model.loggedAt >= startOfDay && model.loggedAt < endOfDay
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.loggedAt, order: .reverse)]
        )

        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func fetchEntries(from startDate: Date, to endDate: Date) async throws -> [FoodItem] {
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        let predicate = #Predicate<FoodEntryModel> { model in
            model.loggedAt >= start && model.loggedAt < end
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.loggedAt, order: .reverse)]
        )

        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func fetchByMealType(_ mealType: MealType, for date: Date) async throws -> [FoodItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let mealTypeString = mealType.rawValue

        let predicate = #Predicate<FoodEntryModel> { model in
            model.loggedAt >= startOfDay && model.loggedAt < endOfDay && model.mealType == mealTypeString
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.loggedAt, order: .reverse)]
        )

        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func fetchByDateRange(start: Date, end: Date) async throws -> [FoodItem] {
        let startOfDay = Calendar.current.startOfDay(for: start)
        let endOfDay = Calendar.current.startOfDay(for: end)

        let predicate = #Predicate<FoodEntryModel> { model in
            model.loggedAt >= startOfDay && model.loggedAt < endOfDay
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.loggedAt, order: .reverse)]
        )

        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func delete(_ entry: FoodItem) async throws {
        let entryId = entry.id
        let predicate = #Predicate<FoodEntryModel> { model in
            model.id == entryId
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(predicate: predicate)

        if let model = try modelContext.fetch(descriptor).first {
            modelContext.delete(model)
            try modelContext.save()
        }
    }

    func update(_ entry: FoodItem) async throws {
        let entryId = entry.id
        let predicate = #Predicate<FoodEntryModel> { model in
            model.id == entryId
        }
        let descriptor = FetchDescriptor<FoodEntryModel>(predicate: predicate)

        if let model = try modelContext.fetch(descriptor).first {
            model.name = entry.name
            model.calories = entry.nutrition.calories
            model.protein = entry.nutrition.protein
            model.carbs = entry.nutrition.carbs
            model.fats = entry.nutrition.fats
            model.fiber = entry.nutrition.fiber
            model.sugar = entry.nutrition.sugar
            model.sodium = entry.nutrition.sodium
            model.mealType = entry.mealType.rawValue
            model.portionAmount = entry.portion.amount
            model.portionUnit = entry.portion.unit
            model.portionDescription = entry.portion.description
            model.confidence = entry.confidence
            model.source = entry.source.rawValue
            model.foodCode = entry.foodCode
            try modelContext.save()
        }
    }
}