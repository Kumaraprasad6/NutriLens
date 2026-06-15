import XCTest
@testable import NutriLens

final class LogFoodUseCaseTests: XCTestCase {
    func testLogFood_Success() async throws {
        let mockRepository = MockFoodRepository()
        let useCase = LogFoodUseCase(repository: mockRepository)

        let entry = createTestFoodEntry(name: "Test Food", calories: 500)

        try await useCase.execute(entry)

        XCTAssertTrue(mockRepository.saveCalled)
        XCTAssertEqual(mockRepository.savedEntry?.id, entry.id)
    }

    func testDeleteEntry_Success() async throws {
        let mockRepository = MockFoodRepository()
        let useCase = LogFoodUseCase(repository: mockRepository)

        let entry = createTestFoodEntry()

        try await useCase.delete(entry)

        XCTAssertTrue(mockRepository.deleteCalled)
    }

    func testUpdateEntry_Success() async throws {
        let mockRepository = MockFoodRepository()
        let useCase = LogFoodUseCase(repository: mockRepository)

        let entry = createTestFoodEntry(name: "Original")
        entry.name = "Updated"

        try await useCase.update(entry)

        XCTAssertTrue(mockRepository.updateCalled)
    }
}

final class GetDailySummaryUseCaseTests: XCTestCase {
    func testExecute_ReturnsCorrectSummary() async throws {
        let mockFoodRepo = MockFoodRepository()
        let mockGoalsRepo = MockGoalsRepository()

        mockFoodRepo.fetchEntriesResult = [
            createTestFoodEntry(calories: 500),
            createTestFoodEntry(calories: 300)
        ]

        let useCase = GetDailySummaryUseCase(
            foodRepository: mockFoodRepo,
            goalsRepository: mockGoalsRepo
        )

        let summary = try await useCase.execute()

        XCTAssertEqual(summary.totalNutrition.calories, 800)
        XCTAssertEqual(summary.entries.count, 2)
        XCTAssertEqual(summary.goal.calories, 2000)
    }

    func testExecute_EmptyEntries() async throws {
        let mockFoodRepo = MockFoodRepository()
        let mockGoalsRepo = MockGoalsRepository()

        mockFoodRepo.fetchEntriesResult = []

        let useCase = GetDailySummaryUseCase(
            foodRepository: mockFoodRepo,
            goalsRepository: mockGoalsRepo
        )

        let summary = try await useCase.execute()

        XCTAssertEqual(summary.totalNutrition.calories, 0)
        XCTAssertTrue(summary.entries.isEmpty)
    }

    func testProgress_CalculatedCorrectly() async throws {
        let mockFoodRepo = MockFoodRepository()
        let mockGoalsRepo = MockGoalsRepository()

        mockFoodRepo.fetchEntriesResult = [
            createTestFoodEntry(calories: 1000, protein: 50)
        ]

        let useCase = GetDailySummaryUseCase(
            foodRepository: mockFoodRepo,
            goalsRepository: mockGoalsRepo
        )

        let summary = try await useCase.execute()

        XCTAssertEqual(summary.progress.calorieProgress, 0.5)
        XCTAssertEqual(summary.progress.proteinProgress, 1.0)
    }
}

final class ManageGoalsUseCaseTests: XCTestCase {
    func testGetGoals_ReturnsGoals() async throws {
        let mockRepository = MockGoalsRepository()
        let useCase = ManageGoalsUseCase(repository: mockRepository)

        let goals = try await useCase.getGoals()

        XCTAssertEqual(goals.calories, 2000)
    }

    func testSaveGoals_Success() async throws {
        let mockRepository = MockGoalsRepository()
        let useCase = ManageGoalsUseCase(repository: mockRepository)

        let goals = NutritionGoal(calories: 2500, protein: 100)

        try await useCase.saveGoals(goals)

        XCTAssertTrue(mockRepository.saveGoalsCalled)
    }

    func testValidateGoals_ValidGoals() {
        let useCase = ManageGoalsUseCase(repository: MockGoalsRepository())

        let goals = NutritionGoal(calories: 2000, protein: 50)

        let errors = useCase.validateGoals(goals)

        XCTAssertTrue(errors.isEmpty)
    }

    func testValidateGoals_InvalidCalories() {
        let useCase = ManageGoalsUseCase(repository: MockGoalsRepository())

        let goals = NutritionGoal(calories: 0)

        let errors = useCase.validateGoals(goals)

        XCTAssertFalse(errors.isEmpty)
        XCTAssertTrue(errors.contains(.invalidCalories))
    }

    func testValidateGoals_CaloriesTooHigh() {
        let useCase = ManageGoalsUseCase(repository: MockGoalsRepository())

        let goals = NutritionGoal(calories: 15000)

        let errors = useCase.validateGoals(goals)

        XCTAssertFalse(errors.isEmpty)
        XCTAssertTrue(errors.contains(.caloriesTooHigh))
    }
}

final class CaptureFoodUseCaseTests: XCTestCase {
    func testCreateManualEntry() {
        let parsingService = MockParsingService()
        let useCase = CaptureFoodUseCase(parsingService: parsingService)

        let entry = useCase.createManualEntry(
            name: "Test Food",
            calories: 500,
            protein: 30,
            carbs: 50,
            fats: 20,
            fiber: 10,
            sugar: 15,
            sodium: 800
        )

        XCTAssertEqual(entry.name, "Test Food")
        XCTAssertEqual(entry.nutrition.calories, 500)
        XCTAssertEqual(entry.nutrition.protein, 30)
    }
}

func createTestFoodEntry(
    name: String = "Test Food",
    calories: Double = 500,
    protein: Double = 25
) -> FoodItem {
    FoodItem(
        name: name,
        nutrition: NutritionInfo(
            calories: calories,
            protein: protein,
            carbs: 50,
            fats: 20,
            fiber: 10,
            sugar: 15,
            sodium: 800
        )
    )
}