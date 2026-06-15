import SwiftUI
import PhotosUI
import AVFoundation

@Observable
final class CaptureViewModel {
    var state: CaptureState = .idle
    var capturedImage: UIImage?
    var capturedImageData: Data?
    var selectedPhotoItem: PhotosPickerItem?
    var showCamera = false
    var showPhotoPicker = false
    var showManualEntry = false
    var cameraPermissionStatus: AVAuthorizationStatus = .notDetermined

    private let captureFoodUseCase: CaptureFoodUseCase

    init(captureFoodUseCase: CaptureFoodUseCase? = nil) {
        let modelContext = Self.createModelContext()
        let databaseService = IFCTDatabaseService(modelContext: modelContext)
        let recognitionService = CoreMLFoodRecognitionService()
        let mappingService = AIToIFCTMappingService()
        self.captureFoodUseCase = captureFoodUseCase ?? CaptureFoodUseCase(
            parsingService: NutritionParsingService(),
            recognitionService: recognitionService,
            mappingService: mappingService,
            databaseService: databaseService
        )
        checkCameraPermission()
    }

    private static func createModelContext() -> ModelContext {
        do {
            let schema = Schema([IFCTFoodModel.self, FoodEntryModel.self, NutritionGoalModel.self])
            let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)])
            return ModelContext(container)
        } catch {
            do {
                let schema = Schema([IFCTFoodModel.self, FoodEntryModel.self, NutritionGoalModel.self])
                let container = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)])
                return ModelContext(container)
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }

    var canUseCamera: Bool {
        cameraPermissionStatus == .authorized
    }

    func checkCameraPermission() {
        cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestCameraPermission() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        await MainActor.run {
            cameraPermissionStatus = granted ? .authorized : .denied
            if granted {
                showCamera = true
            }
        }
    }

    func handlePhotoSelected(_ item: PhotosPickerItem?) async {
        guard let item = item else { return }

        await MainActor.run {
            state = .processing
        }

        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                await MainActor.run {
                    capturedImageData = data
                    capturedImage = UIImage(data: data)
                }
                await processImage(data)
            }
        } catch {
            await MainActor.run {
                state = .error("Failed to load photo: \(error.localizedDescription)")
            }
        }
    }

    func handleImageCaptured(_ image: UIImage) async {
        await MainActor.run {
            capturedImage = image
            state = .processing
        }

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            await MainActor.run {
                state = .error("Failed to process image")
            }
            return
        }

        capturedImageData = data
        await processImage(data)
    }

    private func processImage(_ data: Data) async {
        do {
            await MainActor.run {
                state = .aiClassifying
            }
            let (foodItem, predictions) = try await captureFoodUseCase.execute(imageData: data)
            await MainActor.run {
                state = .review(foodItem, aiPredictions: predictions)
            }
        } catch {
            await MainActor.run {
                state = .error(error.localizedDescription)
            }
        }
    }

    func createManualEntry(
        name: String,
        calories: Double,
        protein: Double,
        carbs: Double,
        fats: Double,
        fiber: Double,
        sugar: Double,
        sodium: Double
    ) {
        let entry = captureFoodUseCase.createManualEntry(
            name: name,
            calories: calories,
            protein: protein,
            carbs: carbs,
            fats: fats,
            fiber: fiber,
            sugar: sugar,
            sodium: sodium
        )
        state = .review(entry, aiPredictions: [])
    }

    func reset() {
        state = .idle
        capturedImage = nil
        capturedImageData = nil
        selectedPhotoItem = nil
    }

    func cancel() {
        state = .cancelled
        reset()
    }
}