import XCTest
@testable import NutriLens

final class PortionTests: XCTestCase {
    func testPortionCreation() {
        let portion = Portion(amount: 2.5, unit: "cup", description: "2.5 cups")
        
        XCTAssertEqual(portion.amount, 2.5)
        XCTAssertEqual(portion.unit, "cup")
        XCTAssertEqual(portion.description, "2.5 cups")
    }
    
    func testPortionDefaults() {
        let portion = Portion.default
        
        XCTAssertEqual(portion.amount, 1.0)
        XCTAssertEqual(portion.unit, "serving")
        XCTAssertEqual(portion.description, "1 serving")
    }
    
    func testPortionFactories() {
        let grams = Portion.grams(150)
        XCTAssertEqual(grams.amount, 150)
        XCTAssertEqual(grams.unit, "g")
        XCTAssertEqual(grams.description, "150g")
        
        let cups = Portion.cups(2)
        XCTAssertEqual(cups.amount, 2)
        XCTAssertEqual(cups.unit, "cup")
        XCTAssertEqual(cups.description, "2 cups")
        
        let pieces = Portion.pieces(3)
        XCTAssertEqual(pieces.amount, 3)
        XCTAssertEqual(pieces.unit, "piece")
        XCTAssertEqual(pieces.description, "3 pieces")
        
        let ounces = Portion.ounces(5)
        XCTAssertEqual(ounces.amount, 5)
        XCTAssertEqual(ounces.unit, "oz")
        XCTAssertEqual(ounces.description, "5oz")
        
        let tbsp = Portion.tablespoons(2)
        XCTAssertEqual(tbsp.amount, 2)
        XCTAssertEqual(tbsp.unit, "tbsp")
        XCTAssertEqual(tbsp.description, "2 tbsp")
        
        let tsp = Portion.teaspoons(1)
        XCTAssertEqual(tsp.amount, 1)
        XCTAssertEqual(tsp.unit, "tsp")
        XCTAssertEqual(tsp.description, "1 tsp")
    }
    
    func testPortionScaling() {
        let portion = Portion.grams(100)
        let scaled = portion.scaled(by: 1.5)
        
        XCTAssertEqual(scaled.amount, 150, accuracy: 0.01)
        XCTAssertEqual(scaled.unit, "g")
        XCTAssertEqual(scaled.description, "150.0 g")
    }
    
    func testPortionEquality() {
        let p1 = Portion.grams(100)
        let p2 = Portion.grams(100)
        let p3 = Portion.cups(1)
        
        XCTAssertEqual(p1, p2)
        XCTAssertNotEqual(p1, p3)
    }
    
    func testPortionCodable() throws {
        let portion = Portion.grams(250)
        let encoded = try JSONEncoder().encode(portion)
        let decoded = try JSONDecoder().decode(Portion.self, from: encoded)
        
        XCTAssertEqual(portion, decoded)
    }
}
