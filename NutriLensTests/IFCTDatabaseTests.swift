import XCTest
@testable import NutriLens

final class IFCTDatabaseTests: XCTestCase {
    private var jsonURL: URL!

    override func setUp() {
        super.setUp()
        jsonURL = Bundle.main.url(forResource: "ifct2017", withExtension: "json")
    }

    func testJSONFileExists() {
        XCTAssertNotNil(jsonURL, "IFCT JSON file should exist in bundle")
        XCTAssertTrue(FileManager.default.fileExists(atPath: jsonURL.path), "File should exist on disk")
    }

    func testJSONLoadsCorrectly() throws {
        let data = try Data(contentsOf: jsonURL)
        let foods = try JSONDecoder().decode([IFCTFoodItem].self, from: data)
        XCTAssertEqual(foods.count, 542, "Should load all 542 foods")
    }

    func testFirstFoodHasCorrectData() throws {
        let data = try Data(contentsOf: jsonURL)
        let foods = try JSONDecoder().decode([IFCTFoodItem].self, from: data)
        let firstFood = foods[0]

        XCTAssertEqual(firstFood.code, "A001")
        XCTAssertEqual(firstFood.name, "Amaranth seed, black")
        XCTAssertEqual(firstFood.group, "Cereals and Millets")
        XCTAssertEqual(firstFood.energy, 1490, accuracy: 0.1)
    }

    func testAllFoodGroupsPresent() throws {
        let data = try Data(contentsOf: jsonURL)
        let foods = try JSONDecoder().decode([IFCTFoodItem].self, from: data)
        let groups = Set(foods.map { $0.group })

        XCTAssertTrue(groups.contains("Cereals and Millets"))
        XCTAssertTrue(groups.contains("Grain Legumes"))
        XCTAssertTrue(groups.contains("Milk and Milk Products"))
        XCTAssertTrue(groups.contains("Fruits"))
        XCTAssertTrue(groups.contains("Vegetables"))
    }

    func testNutritionValuesArePositive() throws {
        let data = try Data(contentsOf: jsonURL)
        let foods = try JSONDecoder().decode([IFCTFoodItem].self, from: data)

        for food in foods {
            XCTAssertGreaterThanOrEqual(food.energy, 0, "\(food.name) energy should be >= 0")
            XCTAssertGreaterThanOrEqual(food.protein, 0, "\(food.name) protein should be >= 0")
            XCTAssertGreaterThanOrEqual(food.fat, 0, "\(food.name) fat should be >= 0")
            XCTAssertGreaterThanOrEqual(food.carbs, 0, "\(food.name) carbs should be >= 0")
        }
    }

    func testPortionCalculations() {
        // Test 1 roti ≈ 80 kcal (30g atta)
        let roti = IndianPortionMapping.roti
        XCTAssertEqual(roti.weightInGrams, 30)

        // Test 1 katori dal ≈ 120 kcal (150g cooked dal)
        let katoriDal = IndianPortionMapping.katoriDal
        XCTAssertEqual(katoriDal.weightInGrams, 150)

        // Test 1 idli ≈ 40 kcal (75g raw batter)
        let idli = IndianPortionMapping.idli
        XCTAssertEqual(idli.weightInGrams, 75)

        // Test 1 dosa (100g batter)
        let dosa = IndianPortionMapping.dosa
        XCTAssertEqual(dosa.weightInGrams, 100)

        // Test 1 chapati (25g wheat flour)
        let chapati = IndianPortionMapping.chapati
        XCTAssertEqual(chapati.weightInGrams, 25)

        // Test 1 bowl rice (150g cooked rice)
        let bowlRice = IndianPortionMapping.bowlRice
        XCTAssertEqual(bowlRice.weightInGrams, 150)

        // Test 1 paratha (50g total)
        let paratha = IndianPortionMapping.paratha
        XCTAssertEqual(paratha.weightInGrams, 50)

        // Test 1 cup tea (215g total)
        let cupTea = IndianPortionMapping.cupTea
        XCTAssertEqual(cupTea.weightInGrams, 215)
    }

    func testNutritionCalculationForPortion() {
        let food = IFCTFoodItem(
            code: "A005",
            name: "Wheat flour",
            group: "Cereals and Millets",
            energy: 348,
            protein: 11,
            fat: 1.5,
            carbs: 73
        )

        let roti = IndianPortionMapping.roti
        let nutrition = IndianPortionMapping.calculateNutrition(for: food, portion: roti)

        // 30g of wheat flour at 348 kcal/100g = ~104 kcal
        // Close to 80 kcal (approximation due to cooking loss)
        XCTAssertEqual(nutrition.calories, 104.4, accuracy: 0.1)
        XCTAssertEqual(nutrition.protein, 3.3, accuracy: 0.1)
        XCTAssertEqual(nutrition.carbs, 21.9, accuracy: 0.1)
    }

    func testIFCTFoodModelMapping() {
        let food = IFCTFoodItem(
            code: "A001",
            name: "Test Food",
            group: "Cereals",
            energy: 100,
            protein: 5,
            fat: 2,
            carbs: 20
        )

        let model = IFCTFoodModel.from(entity: food)
        XCTAssertEqual(model.code, food.code)
        XCTAssertEqual(model.name, food.name)
        XCTAssertEqual(model.group, food.group)
        XCTAssertEqual(model.energy, food.energy)

        let entity = model.toEntity()
        XCTAssertEqual(entity.code, food.code)
        XCTAssertEqual(entity.name, food.name)
        XCTAssertEqual(entity.group, food.group)
        XCTAssertEqual(entity.energy, food.energy)
    }
}
