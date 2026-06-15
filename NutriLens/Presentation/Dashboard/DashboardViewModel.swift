import Foundation
import SwiftData

@Observable
final class DashboardViewModel {
    var isLoading = false
    var errorMessage: String?
    var selectedDate: Date = .now
    var summary: DailySummary?
    var weeklyData: WeeklyData?
    var monthlyData: WeeklyData?
    var selectedTrendPeriod: TrendPeriod = .weekly
    
    // Pinned foods for quick add
    var pinnedFoods: [FoodItem] = []
    
    private let getDailySummaryUseCase: GetDailySummaryUseCase
    private let getWeeklyTrendsUseCase: GetWeeklyTrendsUseCase
    private let foodRepository: FoodRepositoryProtocol
    private let goalsRepository: GoalsRepositoryProtocol
    
    enum TrendPeriod: String, CaseIterable {
        case weekly = "Weekly"
        case monthly = "Monthly"
    }
    
    init(
        getDailySummaryUseCase: GetDailySummaryUseCase? = nil,
        getWeeklyTrendsUseCase: GetWeeklyTrendsUseCase? = nil,
        foodRepository: FoodRepositoryProtocol? = nil,
        goalsRepository: GoalsRepositoryProtocol? = nil
    ) {
        let context = Self.createDefaultContext()
        let foodRepo = foodRepository ?? FoodRepository(modelContext: context)
        let goalsRepo = goalsRepository ?? GoalsRepository(modelContext: context)
        
        self.foodRepository = foodRepo
        self.goalsRepository = goalsRepo
        self.getDailySummaryUseCase = getDailySummaryUseCase ?? GetDailySummaryUseCase(
            foodRepository: foodRepo,
            goalsRepository: goalsRepo
        )
        self.getWeeklyTrendsUseCase = getWeeklyTrendsUseCase ?? GetWeeklyTrendsUseCase(repository: foodRepo)
        
        loadPinnedFoods()
    }
    
    private static func createDefaultContext() -> ModelContext {
        do {
            let schema = Schema([FoodEntryModel.self, NutritionGoalModel.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
            return ModelContext(container)
        } catch {
            print("Failed to create ModelContainer: \(error)")
            do {
                let schema = Schema([FoodEntryModel.self, NutritionGoalModel.self])
                let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
                return ModelContext(container)
            } catch {
                fatalError("Could not create any ModelContainer: \(error)")
            }
        }
    }
    
    init(
        modelContext: ModelContext,
        getDailySummaryUseCase: GetDailySummaryUseCase? = nil,
        getWeeklyTrendsUseCase: GetWeeklyTrendsUseCase? = nil
    ) {
        let foodRepo = FoodRepository(modelContext: modelContext)
        let goalsRepo = GoalsRepository(modelContext: modelContext)
        
        self.foodRepository = foodRepo
        self.goalsRepository = goalsRepo
        self.getDailySummaryUseCase = getDailySummaryUseCase ?? GetDailySummaryUseCase(
            foodRepository: foodRepo,
            goalsRepository: goalsRepo
        )
        self.getWeeklyTrendsUseCase = getWeeklyTrendsUseCase ?? GetWeeklyTrendsUseCase(repository: foodRepo)
        
        loadPinnedFoods()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            summary = try await getDailySummaryUseCase.execute(for: selectedDate)
            await loadTrends()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadTrends() async {
        do {
            weeklyData = try await getWeeklyTrendsUseCase.execute(forWeekContaining: selectedDate)
            monthlyData = try await getWeeklyTrendsUseCase.executeMonthly(forMonthContaining: selectedDate)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func goToPreviousDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) {
            selectedDate = newDate
            Task {
                await loadData()
            }
        }
    }
    
    func goToNextDay() {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) {
            selectedDate = newDate
            Task {
                await loadData()
            }
        }
    }
    
    func goToToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        selectedDate = today
        Task {
            await loadData()
        }
    }
    
    func deleteEntry(_ entry: FoodItem) async {
        do {
            try await foodRepository.delete(entry)
            await loadData()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Quick Add
    
    func quickAddFood(_ food: FoodItem) {
        Task {
            do {
                try await foodRepository.save(food)
                await loadData()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func addManualEntry(
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fats: Double,
        fiber: Double,
        sugar: Double,
        sodium: Double
    ) {
        let foodItem = FoodItem(
            name: name,
            nutrition: NutritionInfo(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                fiber: fiber,
                sugar: sugar,
                sodium: sodium
            )
        )
        
        Task {
            do {
                try await foodRepository.save(foodItem)
                await loadData()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Pinned Foods
    
    private func loadPinnedFoods() {
        // Default pinned foods for quick add
        pinnedFoods = [
            FoodItem(
                name: "Apple",
                nutrition: NutritionInfo(calories: 95, protein: 0.5, carbs: 25, fats: 0.3, fiber: 4, sugar: 19, sodium: 2)
            ),
            FoodItem(
                name: "Banana",
                nutrition: NutritionInfo(calories: 105, protein: 1.3, carbs: 27, fats: 0.3, fiber: 3, sugar: 14, sodium: 1)
            ),
            FoodItem(
                name: "Salad",
                nutrition: NutritionInfo(calories: 320, protein: 12, carbs: 18, fats: 8, fiber: 5, sugar: 6, sodium: 180)
            ),
            FoodItem(
                name: "Greek Yogurt",
                nutrition: NutritionInfo(calories: 120, protein: 15, carbs: 8, fats: 0, fiber: 0, sugar: 7, sodium: 60)
            ),
            FoodItem(
                name: "Chicken Breast",
                nutrition: NutritionInfo(calories: 165, protein: 31, carbs: 0, fats: 3.6, fiber: 0, sugar: 0, sodium: 74)
            ),
            FoodItem(
                name: "Rice Bowl",
                nutrition: NutritionInfo(calories: 280, protein: 6, carbs: 58, fats: 1, fiber: 2, sugar: 0, sodium: 10)
            )
        ]
    }
}