import Foundation
import UIKit

final class CaptureFoodUseCase {
    private let parsingService: NutritionParsingServiceProtocol
    private let recognitionService: FoodRecognitionServiceProtocol
    private let mappingService: AIToIFCTMappingProtocol
    private let databaseService: IFCTDatabaseServiceProtocol

    init(
        parsingService: NutritionParsingServiceProtocol,
        recognitionService: FoodRecognitionServiceProtocol,
        mappingService: AIToIFCTMappingProtocol,
        databaseService: IFCTDatabaseServiceProtocol
    ) {
        self.parsingService = parsingService
        self.recognitionService = recognitionService
        self.mappingService = mappingService
        self.databaseService = databaseService
    }

    func execute(imageData: Data) async throws -> (FoodItem, [FoodRecognitionResult]) {
        let foodItem = try await parsingService.parseFood(from: imageData)

        guard let image = UIImage(data: imageData),
              recognitionService.isModelAvailable() else {
            return (foodItem, [])
        }

        let predictions = try await recognitionService.classify(image: image)
        let mapped = await mappingService.map(
            predictions: predictions,
            databaseService: databaseService
        )

        return (foodItem, mapped)
    }

    func createManualEntry(
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fats: Double,
        fiber: Double,
        sugar: Double,
        sodium: Double,
        imageData: Data? = nil
    ) -> FoodItem {
        FoodItem(
            name: name,
            nutrition: NutritionInfo(
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                fiber: fiber,
                sugar: sugar,
                sodium: sodium
            ),
            imageData: imageData
        )
    }
}