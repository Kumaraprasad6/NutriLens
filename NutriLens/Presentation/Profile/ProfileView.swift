import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    Text("Profile & Settings")
                        .font(AppTheme.Typography.title1)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Your profile and settings will appear here")
                        .font(AppTheme.Typography.body)
                        .foregroundStyle(AppTheme.Colors.textSecondary)
                        .frame(maxWidth: .infinity, minHeight: 200)
                }
                .padding()
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}