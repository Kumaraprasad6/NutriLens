import XCTest
@testable import NutriLens

final class MealTypeTests: XCTestCase {
    func testMealTypeFromTime() {
        let calendar = Calendar.current
        
        let breakfastTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        XCTAssertEqual(MealType.from(time: breakfastTime), .breakfast)
        
        let lunchTime = calendar.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!
        XCTAssertEqual(MealType.from(time: lunchTime), .lunch)
        
        let dinnerTime = calendar.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        XCTAssertEqual(MealType.from(time: dinnerTime), .dinner)
        
        let snackTime = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        XCTAssertEqual(MealType.from(time: snackTime), .snack)
    }
    
    func testMealTypeEmojis() {
        XCTAssertEqual(MealType.breakfast.emoji, "🍳")
        XCTAssertEqual(MealType.lunch.emoji, "🥗")
        XCTAssertEqual(MealType.dinner.emoji, "🍽️")
        XCTAssertEqual(MealType.snack.emoji, "🍎")
    }
    
    func testMealTypeDisplayNames() {
        XCTAssertEqual(MealType.breakfast.displayName, "Breakfast")
        XCTAssertEqual(MealType.lunch.displayName, "Lunch")
        XCTAssertEqual(MealType.dinner.displayName, "Dinner")
        XCTAssertEqual(MealType.snack.displayName, "Snack")
    }
    
    func testMealTypeCodable() throws {
        let mealType = MealType.lunch
        let encoded = try JSONEncoder().encode(mealType)
        let decoded = try JSONDecoder().decode(MealType.self, from: encoded)
        XCTAssertEqual(mealType, decoded)
    }
    
    func testMealTypeAllCases() {
        let allCases = MealType.allCases
        XCTAssertEqual(allCases.count, 4)
        XCTAssertTrue(allCases.contains(.breakfast))
        XCTAssertTrue(allCases.contains(.lunch))
        XCTAssertTrue(allCases.contains(.dinner))
        XCTAssertTrue(allCases.contains(.snack))
    }
}
