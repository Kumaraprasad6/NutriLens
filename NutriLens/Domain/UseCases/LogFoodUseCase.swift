import Foundation

final class LogFoodUseCase {
    private let repository: FoodRepositoryProtocol

    init(repository: FoodRepositoryProtocol) {
        self.repository = repository
    }

    func execute(_ entry: FoodItem) async throws {
        try await repository.save(entry)
    }

    func delete(_ entry: FoodItem) async throws {
        try await repository.delete(entry)
    }

    func update(_ entry: FoodItem) async throws {
        try await repository.update(entry)
    }
}