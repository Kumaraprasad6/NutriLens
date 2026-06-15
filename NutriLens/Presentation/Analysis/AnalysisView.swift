import SwiftUI

struct AnalysisView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    Text("Insights & Analysis")
                        .font(AppTheme.Typography.title1)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Nutrition insights and trends will appear here")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                }
                .padding()
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Analysis")
        }
    }
}

#Preview {
    AnalysisView()
}