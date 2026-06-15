import Foundation
import SwiftData

@Observable
final class SearchViewModel {
    var searchQuery: String = ""
    var searchResults: [IFCTFoodItem] = []
    var selectedGroup: String? = nil
    var foodGroups: [String] = []
    var recentSearches: [String] = []
    var isLoading: Bool = false
    var isImporting: Bool = false
    var errorMessage: String? = nil
    var selectedFood: IFCTFoodItem? = nil
    var showDetailSheet: Bool = false

    private let databaseService: IFCTDatabaseServiceProtocol
    private let recentSearchesKey = "recent_searches"
    private let maxRecentSearches = 10

    init(databaseService: IFCTDatabaseServiceProtocol? = nil) {
        if let service = databaseService {
            self.databaseService = service
        } else {
            self.databaseService = IFCTDatabaseService(modelContext: Self.createDefaultContext())
        }
        loadRecentSearches()
    }
    
    private static func createDefaultContext() -> ModelContext {
        do {
            let schema = Schema([IFCTFoodModel.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
            return ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            do {
                let schema = Schema([IFCTFoodModel.self])
                let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
                return ModelContext(container)
            } catch {
                fatalError("Could not create any ModelContainer: \(error)")
            }
        }
    }

    func importDatabase() async {
        isImporting = true
        defer { isImporting = false }

        do {
            try await databaseService.importDatabase()
            await loadFoodGroups()
        } catch {
            errorMessage = "Failed to import database: \(error.localizedDescription)"
        }
    }

    func checkAndImport() async {
        let isImported = await databaseService.isDatabaseImported()
        if !isImported {
            await importDatabase()
        } else {
            await loadFoodGroups()
        }
    }

    func search() async {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            searchResults = try await databaseService.searchFoods(query: searchQuery)
            addToRecentSearches(searchQuery)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
    }

    func filterByGroup(_ group: String?) async {
        selectedGroup = group
        isLoading = true
        defer { isLoading = false }

        do {
            if let group = group {
                searchResults = try await databaseService.getFoodsByGroup(group: group)
            } else {
                searchResults = []
            }
        } catch {
            errorMessage = "Filter failed: \(error.localizedDescription)"
        }
    }

    func selectFood(_ food: IFCTFoodItem) {
        selectedFood = food
        showDetailSheet = true
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
        selectedGroup = nil
    }

    func removeRecentSearch(_ query: String) {
        recentSearches.removeAll { $0 == query }
        saveRecentSearches()
    }

    func clearRecentSearches() {
        recentSearches = []
        saveRecentSearches()
    }

    private func loadFoodGroups() async {
        do {
            foodGroups = try await databaseService.getAllFoodGroups()
        } catch {
            errorMessage = "Failed to load food groups: \(error.localizedDescription)"
        }
    }

    private func addToRecentSearches(_ query: String) {
        recentSearches.removeAll { $0 == query }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > maxRecentSearches {
            recentSearches = Array(recentSearches.prefix(maxRecentSearches))
        }
        saveRecentSearches()
    }

    private func loadRecentSearches() {
        if let data = UserDefaults.standard.data(forKey: recentSearchesKey),
           let searches = try? JSONDecoder().decode([String].self, from: data) {
            recentSearches = searches
        }
    }

    private func saveRecentSearches() {
        if let data = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(data, forKey: recentSearchesKey)
        }
    }
}
