import SwiftUI
import PhotosUI

struct CaptureHomeView: View {
    @State private var viewModel = CaptureViewModel()
    @State private var navigateToReview = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.Colors.groupedBackground
                    .ignoresSafeArea()

                VStack(spacing: AppTheme.Spacing.lg) {
                    headerSection

                    captureOptionsSection

                    Spacer()

                    manualEntryButton
                }
                .padding()
            }
            .navigationTitle("Capture Food")
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(isPresented: $navigateToReview) {
                if case .review(let foodItem, let predictions) = viewModel.state {
                    NutritionReviewView(
                        foodItem: foodItem,
                        aiPredictions: predictions
                    ) {
                        viewModel.reset()
                        navigateToReview = false
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.showCamera) {
                CameraView { image in
                    viewModel.showCamera = false
                    Task {
                        await viewModel.handleImageCaptured(image)
                    }
                }
            }
            .onChange(of: viewModel.state) { _, newState in
                if case .review = newState {
                    navigateToReview = true
                }
            }
            .overlay {
                if case .processing = viewModel.state {
                    processingOverlay(message: "Processing image...")
                } else if case .aiClassifying = viewModel.state {
                    processingOverlay(message: "Identifying food...")
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 60))
                .foregroundStyle(AppTheme.Colors.primary)

            Text("Capture your meal")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Take a photo or choose from your library to get nutrition info")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppTheme.Spacing.xl)
    }

    private var captureOptionsSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                captureOptionCard(
                    icon: "photo.on.rectangle",
                    title: "Photo Library",
                    subtitle: "Choose an existing photo"
                )
            }
            .buttonStyle(.plain)
            .onChange(of: viewModel.selectedPhotoItem) { _, newItem in
                Task {
                    await viewModel.handlePhotoSelected(newItem)
                }
            }

            Button {
                Task {
                    if viewModel.canUseCamera {
                        viewModel.showCamera = true
                    } else {
                        await viewModel.requestCameraPermission()
                    }
                }
            } label: {
                captureOptionCard(
                    icon: "camera.fill",
                    title: "Camera",
                    subtitle: "Take a new photo"
                )
            }
            .buttonStyle(.plain)

            if viewModel.cameraPermissionStatus == .denied {
                Text("Camera access denied. Enable in Settings.")
                    .font(.caption)
                    .foregroundStyle(AppTheme.Colors.error)
            }
        }
    }

    private func captureOptionCard(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppTheme.Colors.primary)
                .frame(width: 50, height: 50)
                .background(AppTheme.Colors.primary.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
    }

    private func processingOverlay(message: String) -> some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.md) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                Text(message)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            .padding(AppTheme.Spacing.xl)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
        }
    }

    private var manualEntryButton: some View {
        NavigationLink {
            ManualEntryView { name, calories, protein, carbs, fats, fiber, sugar, sodium in
                viewModel.createManualEntry(
                    name: name,
                    calories: calories,
                    protein: protein,
                    carbs: carbs,
                    fats: fats,
                    fiber: fiber,
                    sugar: sugar,
                    sodium: sodium
                )
            }
        } label: {
            HStack {
                Image(systemName: "square.and.pencil")
                Text("Enter Manually")
            }
            .font(.headline)
            .foregroundStyle(AppTheme.Colors.primary)
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppTheme.Colors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
        }
    }
}

#Preview {
    CaptureHomeView()
}