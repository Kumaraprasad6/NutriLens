import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: LogViewModel
    
    init() {
        self._viewModel = State(initialValue: LogViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    Text("History & Log")
                        .font(AppTheme.Typography.title1)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Your food history will appear here")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                }
                .padding()
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("History")
            .task {
                viewModel = LogViewModel(modelContext: modelContext)
            }
        }
    }
}

@Observable
final class LogViewModel {
    init() {}
    
    init(modelContext: ModelContext) {
        // Initialize with model context
    }
}

#Preview {
    LogView()
        .modelContainer(for: [FoodEntryModel.self, NutritionGoalModel.self], inMemory: true)
}