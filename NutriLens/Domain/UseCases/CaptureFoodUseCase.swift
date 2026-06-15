import Foundation

final class CaptureFoodUseCase {
    private let parsingService: NutritionParsingServiceProtocol

    init(parsingService: NutritionParsingServiceProtocol) {
        self.parsingService = parsingService
    }

    func execute(imageData: Data) async throws -> FoodItem {
        try await parsingService.parseFood(from: imageData)
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