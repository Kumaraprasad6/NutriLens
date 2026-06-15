import Foundation

enum NutritionConstants {
    static let defaultCalories: Double = 2000
    static let defaultProtein: Double = 50
    static let defaultCarbs: Double = 250
    static let defaultFats: Double = 65
    static let defaultFiber: Double = 30
    static let defaultSugar: Double = 50
    static let defaultSodium: Double = 2300
}

enum CaptureSource {
    case camera
    case photoLibrary
    case manual
}

enum CaptureState: Equatable {
    case idle
    case capturing
    case processing
    case review(FoodItem)
    case confirmed
    case cancelled
    case error(String)
}