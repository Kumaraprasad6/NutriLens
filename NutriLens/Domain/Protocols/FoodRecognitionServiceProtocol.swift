import Foundation
import UIKit

protocol FoodRecognitionServiceProtocol {
    func classify(image: UIImage) async throws -> [FoodRecognitionResult]
    func isModelAvailable() -> Bool
}
