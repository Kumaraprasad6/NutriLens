import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content area
            Group {
                switch selectedTab {
                case .home:
                    DashboardView(
                        onNavigateToLog: {
                            selectedTab = .log
                        }
                    )
                case .log:
                    LogView()
                case .camera:
                    CaptureHomeView()
                case .analysis:
                    AnalysisView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [FoodEntryModel.self, NutritionGoalModel.self], inMemory: true)
}