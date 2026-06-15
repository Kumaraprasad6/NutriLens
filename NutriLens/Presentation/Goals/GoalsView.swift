import SwiftUI
import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: GoalsViewModel

    init() {
        self._viewModel = State(initialValue: GoalsViewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Set your daily nutrition targets to track your progress and stay on course with your health goals.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section {
                    goalField(
                        label: "Calories",
                        value: $viewModel.caloriesText,
                        unit: "kcal",
                        icon: "flame.fill",
                        color: AppTheme.Colors.calories
                    )
                } header: {
                    Text("Energy")
                }

                Section {
                    goalField(
                        label: "Protein",
                        value: $viewModel.proteinText,
                        unit: "g",
                        icon: "fish.fill",
                        color: AppTheme.Colors.protein
                    )
                    goalField(
                        label: "Carbs",
                        value: $viewModel.carbsText,
                        unit: "g",
                        icon: "leaf.fill",
                        color: AppTheme.Colors.carbs
                    )
                    goalField(
                        label: "Fats",
                        value: $viewModel.fatsText,
                        unit: "g",
                        icon: "drop.fill",
                        color: AppTheme.Colors.fats
                    )
                } header: {
                    Text("Macronutrients")
                }

                Section {
                    goalField(
                        label: "Fiber",
                        value: $viewModel.fiberText,
                        unit: "g",
                        icon: "leaf.circle.fill",
                        color: AppTheme.Colors.fiber
                    )
                    goalField(
                        label: "Sugar",
                        value: $viewModel.sugarText,
                        unit: "g",
                        icon: "cube.fill",
                        color: AppTheme.Colors.sugar
                    )
                    goalField(
                        label: "Sodium",
                        value: $viewModel.sodiumText,
                        unit: "mg",
                        icon: "sparkles",
                        color: AppTheme.Colors.sodium
                    )
                } header: {
                    Text("Micronutrients & Others")
                }

                Section {
                    Button {
                        Task {
                            await viewModel.saveGoals()
                        }
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isSaving {
                                ProgressView()
                            } else {
                                Text("Save Goals")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(viewModel.isSaving)

                    Button {
                        viewModel.resetToDefaults()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reset to Defaults")
                            Spacer()
                        }
                    }
                    .foregroundStyle(AppTheme.Colors.error)
                }

                Section {
                    cloudSyncInfoSection
                } header: {
                    Text("Cloud Sync")
                } footer: {
                    Text("Cloud sync will be available in a future update. Your data is stored locally for now.")
                }
            }
            .navigationTitle("Goals")
            .task {
                viewModel = GoalsViewModel(modelContext: modelContext)
                await viewModel.loadGoals()
            }
            .alert("Error", isPresented: .init(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Goals Saved", isPresented: $viewModel.showSaveSuccess) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your nutrition goals have been updated successfully.")
            }
        }
    }

    private func goalField(
        label: String,
        value: Binding<String>,
        unit: String,
        icon: String,
        color: Color
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(label)

            Spacer()

            TextField("0", text: value)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)

            Text(unit)
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
        }
    }

    private var cloudSyncInfoSection: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "icloud")
                .font(.title2)
                .foregroundStyle(AppTheme.Colors.primary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Coming Soon")
                    .font(.headline)
                Text("Sync your nutrition data across devices with iCloud")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

#Preview {
    GoalsView()
        .modelContainer(for: [NutritionGoalModel.self], inMemory: true)
}