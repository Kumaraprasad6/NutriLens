import Foundation
import SwiftData

final class GoalsRepository: GoalsRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func getGoals() async throws -> NutritionGoal {
        let descriptor = FetchDescriptor<NutritionGoalModel>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        let models = try modelContext.fetch(descriptor)
        if let latest = models.first {
            return latest.toEntity()
        }

        let defaultGoal = NutritionGoalModel()
        modelContext.insert(defaultGoal)
        try modelContext.save()
        return defaultGoal.toEntity()
    }

    func saveGoals(_ goals: NutritionGoal) async throws {
        let descriptor = FetchDescriptor<NutritionGoalModel>()
        let existingModels = try modelContext.fetch(descriptor)
        for model in existingModels {
            modelContext.delete(model)
        }

        let model = NutritionGoalModel.from(entity: goals)
        modelContext.insert(model)
        try modelContext.save()
    }
}