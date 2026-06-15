import Foundation
import UIKit

struct FoodRecognitionResult: Identifiable, Equatable {
    let id: UUID
    let foodName: String
    let confidence: Double
    let boundingBox: CGRect?
    var mappedFoodItem: IFCTFoodItem?
    var mappedNutrition: NutritionInfo?

    init(
        id: UUID = UUID(),
        foodName: String,
        confidence: Double,
        boundingBox: CGRect? = nil,
        mappedFoodItem: IFCTFoodItem? = nil,
        mappedNutrition: NutritionInfo? = nil
    ) {
        self.id = id
        self.foodName = foodName
        self.confidence = confidence
        self.boundingBox = boundingBox
        self.mappedFoodItem = mappedFoodItem
        self.mappedNutrition = mappedNutrition
    }

    var confidenceDisplay: String {
        String(format: "%.0f%%", confidence * 100)
    }

    var isHighConfidence: Bool {
        confidence >= 0.9
    }

    var isMediumConfidence: Bool {
        confidence >= 0.6 && confidence < 0.9
    }

    var isLowConfidence: Bool {
        confidence < 0.6
    }
}
