import Foundation
import UIKit

final class NutritionParsingService: NutritionParsingServiceProtocol {
    private let sampleFoodDatabase: [String: NutritionInfo] = [
        "apple": NutritionInfo(calories: 95, protein: 0.5, carbs: 25, fats: 0.3, fiber: 4.4, sugar: 19, sodium: 2),
        "banana": NutritionInfo(calories: 105, protein: 1.3, carbs: 27, fats: 0.4, fiber: 3.1, sugar: 14, sodium: 1),
        "chicken breast": NutritionInfo(calories: 165, protein: 31, carbs: 0, fats: 3.6, fiber: 0, sugar: 0, sodium: 74),
        "rice": NutritionInfo(calories: 206, protein: 4.3, carbs: 45, fats: 0.4, fiber: 0.6, sugar: 0.1, sodium: 1.6),
        "salmon": NutritionInfo(calories: 208, protein: 20, carbs: 0, fats: 13, fiber: 0, sugar: 0, sodium: 59),
        "egg": NutritionInfo(calories: 78, protein: 6, carbs: 0.6, fats: 5, fiber: 0, sugar: 0.6, sodium: 62),
        "bread": NutritionInfo(calories: 79, protein: 2.7, carbs: 15, fats: 1, fiber: 0.6, sugar: 1.5, sodium: 147),
        "pasta": NutritionInfo(calories: 220, protein: 8, carbs: 43, fats: 1.3, fiber: 2.5, sugar: 0.6, sodium: 1),
        "broccoli": NutritionInfo(calories: 55, protein: 3.7, carbs: 11, fats: 0.6, fiber: 5.1, sugar: 2.2, sodium: 64),
        "avocado": NutritionInfo(calories: 234, protein: 2.9, carbs: 12, fats: 21, fiber: 10, sugar: 1.3, sodium: 10)
    ]

    func parseFood(from imageData: Data) async throws -> FoodItem {
        try await Task.sleep(nanoseconds: 1_500_000_000)

        guard UIImage(data: imageData) != nil else {
            throw FoodCaptureError.parsingFailed("Invalid image data")
        }

        let randomFoods = ["Grilled Chicken Salad", "Fruit Bowl", "Protein Smoothie", "Veggie Wrap", "Fish and Rice"]
        let foodName = randomFoods.randomElement() ?? "Mixed Meal"

        let nutrition = generateSampleNutrition(for: foodName)

        return FoodItem(
            name: foodName,
            nutrition: nutrition,
            imageData: imageData,
            loggedAt: .now
        )
    }

    func generateSampleNutrition(for name: String) -> NutritionInfo {
        let nameLower = name.lowercased()

        for (keyword, nutrition) in sampleFoodDatabase {
            if nameLower.contains(keyword) {
                return nutrition
            }
        }

        return NutritionInfo(
            calories: Double.random(in: 150...600),
            protein: Double.random(in: 5...40),
            carbs: Double.random(in: 20...80),
            fats: Double.random(in: 5...30),
            fiber: Double.random(in: 2...15),
            sugar: Double.random(in: 5...30),
            sodium: Double.random(in: 200...1500)
        )
    }
}

enum FoodCaptureError: Error, LocalizedError {
    case cameraUnavailable
    case photoLibraryDenied
    case parsingFailed(String)
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera is not available on this device"
        case .photoLibraryDenied:
            return "Photo library access was denied"
        case .parsingFailed(let reason):
            return "Failed to parse food: \(reason)"
        case .saveFailed:
            return "Failed to save the food entry"
        }
    }
}