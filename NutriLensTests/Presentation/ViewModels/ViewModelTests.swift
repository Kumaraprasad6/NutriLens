import XCTest
@testable import NutriLens

@MainActor
final class DashboardViewModelTests: XCTestCase {
    func testInitialState() {
        let viewModel = DashboardViewModel(
            foodRepository: MockFoodRepository(),
            goalsRepository: MockGoalsRepository()
        )

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.isToday)
    }

    func testLoadData_Success() async {
        let mockFoodRepo = MockFoodRepository()
        mockFoodRepo.fetchEntriesResult = [
            createTestFoodEntry(calories: 500),
            createTestFoodEntry(calories: 300)
        ]

        let viewModel = DashboardViewModel(
            foodRepository: mockFoodRepo,
            goalsRepository: MockGoalsRepository()
        )

        await viewModel.loadData()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.summary?.totalNutrition.calories, 800)
    }

    func testLoadData_WithError() async {
        struct FailingRepository: FoodRepositoryProtocol {
            func save(_ entry: FoodItem) async throws {}
            func fetchEntries(for date: Date) async throws -> [FoodItem] {
                throw NSError(domain: "Test", code: 1)
            }
            func fetchEntries(from startDate: Date, to endDate: Date) async throws -> [FoodItem] {
                throw NSError(domain: "Test", code: 1)
            }
            func delete(_ entry: FoodItem) async throws {}
            func update(_ entry: FoodItem) async throws {}
        }

        let viewModel = DashboardViewModel(
            foodRepository: FailingRepository(),
            goalsRepository: MockGoalsRepository()
        )

        await viewModel.loadData()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testGoToPreviousDay() async {
        let viewModel = DashboardViewModel(
            foodRepository: MockFoodRepository(),
            goalsRepository: MockGoalsRepository()
        )

        let originalDate = viewModel.selectedDate
        viewModel.goToPreviousDay()

        XCTAssertFalse(viewModel.isToday)
        XCTAssertNotEqual(viewModel.selectedDate, originalDate)
    }

    func testGoToToday() async {
        let viewModel = DashboardViewModel(
            foodRepository: MockFoodRepository(),
            goalsRepository: MockGoalsRepository()
        )

        viewModel.goToPreviousDay()
        viewModel.goToPreviousDay()
        XCTAssertFalse(viewModel.isToday)

        viewModel.goToToday()

        XCTAssertTrue(viewModel.isToday)
    }
}

@MainActor
final class GoalsViewModelTests: XCTestCase {
    func testInitialState() {
        let viewModel = GoalsViewModel(manageGoalsUseCase: ManageGoalsUseCase(
            repository: MockGoalsRepository()
        ))

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isSaving)
    }

    func testResetToDefaults() {
        let viewModel = GoalsViewModel(manageGoalsUseCase: ManageGoalsUseCase(
            repository: MockGoalsRepository()
        ))

        viewModel.caloriesText = "3000"
        viewModel.proteinText = "150"

        viewModel.resetToDefaults()

        XCTAssertEqual(viewModel.caloriesText, "2000")
        XCTAssertEqual(viewModel.proteinText, "50")
    }

    func testSaveGoals_Success() async {
        let viewModel = GoalsViewModel(manageGoalsUseCase: ManageGoalsUseCase(
            repository: MockGoalsRepository()
        ))

        viewModel.caloriesText = "2500"
        viewModel.proteinText = "100"
        viewModel.carbsText = "300"
        viewModel.fatsText = "80"
        viewModel.fiberText = "40"
        viewModel.sugarText = "60"
        viewModel.sodiumText = "2500"

        await viewModel.saveGoals()

        XCTAssertTrue(viewModel.showSaveSuccess)
    }

    func testSaveGoals_InvalidInput() async {
        let viewModel = GoalsViewModel(manageGoalsUseCase: ManageGoalsUseCase(
            repository: MockGoalsRepository()
        ))

        viewModel.caloriesText = "invalid"
        viewModel.proteinText = "100"

        await viewModel.saveGoals()

        XCTAssertNotNil(viewModel.errorMessage)
    }
}

@MainActor
final class CaptureViewModelTests: XCTestCase {
    func testInitialState() {
        let viewModel = CaptureViewModel()

        if case .idle = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected initial state to be idle")
        }
    }

    func testCreateManualEntry() {
        let viewModel = CaptureViewModel()

        viewModel.createManualEntry(
            name: "Test Food",
            calories: 500,
            protein: 30,
            carbs: 50,
            fats: 20,
            fiber: 10,
            sugar: 15,
            sodium: 800
        )

        if case .review(let foodItem, let predictions) = viewModel.state {
            XCTAssertEqual(foodItem.name, "Test Food")
            XCTAssertEqual(foodItem.nutrition.calories, 500)
            XCTAssertTrue(predictions.isEmpty)
        } else {
            XCTFail("Expected state to be review")
        }
    }

    func testReset() {
        let viewModel = CaptureViewModel()

        viewModel.createManualEntry(name: "Test", calories: 500, protein: 30, carbs: 50, fats: 20, fiber: 10, sugar: 15, sodium: 800)
        viewModel.reset()

        if case .idle = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected state to be idle after reset")
        }
    }
}