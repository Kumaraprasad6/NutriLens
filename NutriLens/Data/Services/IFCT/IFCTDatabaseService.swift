import Foundation
import SwiftData

protocol IFCTDatabaseServiceProtocol {
    func searchFoods(query: String) async throws -> [IFCTFoodItem]
    func getFoodByCode(code: String) async throws -> IFCTFoodItem?
    func getFoodsByGroup(group: String) async throws -> [IFCTFoodItem]
    func getAllFoodGroups() async throws -> [String]
    func isDatabaseImported() async -> Bool
    func importDatabase() async throws
}

final class IFCTDatabaseService: IFCTDatabaseServiceProtocol {
    private let modelContext: ModelContext
    private let jsonURL: URL
    private let importKey = "ifct_database_imported"

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.jsonURL = Bundle.main.url(forResource: "ifct2017", withExtension: "json")!
    }

    func isDatabaseImported() async -> Bool {
        UserDefaults.standard.bool(forKey: importKey)
    }

    func importDatabase() async throws {
        guard !(await isDatabaseImported()) else { return }

        let data = try Data(contentsOf: jsonURL)
        let foods = try JSONDecoder().decode([IFCTFoodItem].self, from: data)

        for food in foods {
            let model = IFCTFoodModel.from(entity: food)
            modelContext.insert(model)
        }

        try modelContext.save()
        UserDefaults.standard.set(true, forKey: importKey)
    }

    func searchFoods(query: String) async throws -> [IFCTFoodItem] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return [] }

        let lowerQuery = trimmedQuery.lowercased()
        let predicate = #Predicate<IFCTFoodModel> { model in
            model.name.localizedStandardContains(lowerQuery) ||
            model.localNames.localizedStandardContains(lowerQuery) ||
            model.scientificName.localizedStandardContains(lowerQuery)
        }

        let descriptor = FetchDescriptor<IFCTFoodModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )

        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func getFoodByCode(code: String) async throws -> IFCTFoodItem? {
        let predicate = #Predicate<IFCTFoodModel> { model in
            model.code == code
        }
        let descriptor = FetchDescriptor<IFCTFoodModel>(predicate: predicate)
        let models = try modelContext.fetch(descriptor)
        return models.first?.toEntity()
    }

    func getFoodsByGroup(group: String) async throws -> [IFCTFoodItem] {
        let predicate = #Predicate<IFCTFoodModel> { model in
            model.group == group
        }
        let descriptor = FetchDescriptor<IFCTFoodModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func getAllFoodGroups() async throws -> [String] {
        let descriptor = FetchDescriptor<IFCTFoodModel>()
        let models = try modelContext.fetch(descriptor)
        let groups = Set(models.map { $0.group })
        return Array(groups).sorted()
    }
}
