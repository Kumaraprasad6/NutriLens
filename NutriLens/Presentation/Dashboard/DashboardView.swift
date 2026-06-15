import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: DashboardViewModel
    @State private var animateOnAppear = true
    @State private var cardsVisible = false
    @State private var pendingFoodItem: FoodItem? = nil
    
    let onNavigateToLog: (() -> Void)?
    
    init(onNavigateToLog: (() -> Void)? = nil) {
        self.onNavigateToLog = onNavigateToLog
        self._viewModel = State(initialValue: DashboardViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    // Profile Header
                    profileHeader
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                    
                    // Hero Section
                    heroSection
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                    
                    // Macro Section
                    macroSection
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                    
                    // Quick Add Section
                    quickAddSection
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                    
                    // Today's Log
                    logSection
                        .opacity(cardsVisible ? 1 : 0)
                        .offset(y: cardsVisible ? 0 : 20)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.xl)
                .padding(.bottom, 120) // Space for tab bar
            }
            .background(AppTheme.Colors.background)
            .navigationBarHidden(true)
            .refreshable {
                await viewModel.loadData()
            }
            .sheet(item: $pendingFoodItem) { food in
                QuickAddConfirmationSheet(food: food) {
                    viewModel.quickAddFood(food)
                }
            }
            .task {
                viewModel = DashboardViewModel(modelContext: modelContext)
                await viewModel.loadData()
                
                // Staggered card animation on first appear only
                if animateOnAppear {
                    for i in 0..<5 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) {
                            withAnimation(.easeOut(duration: 0.4)) {
                                cardsVisible = true
                            }
                        }
                    }
                    animateOnAppear = false
                } else {
                    cardsVisible = true
                }
            }
        }
    }
    
    // MARK: - Hero Section
    private var heroSection: some View {
        NutriCard {
            VStack(spacing: AppTheme.Spacing.xl) {
                // Calorie Ring
                ZStack {
                    CircularProgressRing(
                        progress: viewModel.summary?.progress.calorieProgress ?? 0,
                        color: AppTheme.Colors.calories,
                        lineWidth: 14,
                        size: 220,
                        showGlow: true
                    )
                    
                    // Inner text
                    VStack(spacing: 4) {
                        AnimatedCounter(
                            value: Int(viewModel.summary?.totalNutrition.calories ?? 0),
                            font: AppTheme.Typography.largeNumber,
                            color: AppTheme.Colors.textPrimary
                        )
                        
                        Text("/ \(Int(viewModel.summary?.goal.calories ?? 2000)) kcal")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        
                        let remaining = (viewModel.summary?.goal.calories ?? 2000) - (viewModel.summary?.totalNutrition.calories ?? 0)
                        Text("Remaining: \(Int(remaining)) kcal")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(remaining > 0 ? AppTheme.Colors.success : AppTheme.Colors.error)
                    }
                }
                
                // Date Navigator
                HStack {
                    Button {
                        viewModel.goToPreviousDay()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text(viewModel.isToday ? "Today" : viewModel.formattedDate)
                            .font(AppTheme.Typography.title3)
                            .fontWeight(.semibold)
                        
                        if !viewModel.isToday {
                            Button("Go to Today") {
                                viewModel.goToToday()
                            }
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.goToNextDay()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundStyle(AppTheme.Colors.primary)
                    }
                    .disabled(viewModel.isToday)
                    .opacity(viewModel.isToday ? 0.3 : 1)
                }
                .padding(.horizontal, AppTheme.Spacing.sm)
            }
        }
    }
    
    // MARK: - Quick Add Section
    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("⚡ Quick Add")
                    .font(AppTheme.Typography.title2)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                NavigationLink {
                    SearchView { food in
                        let nutrition = food.nutritionForGrams(100)
                        viewModel.addManualEntry(
                            name: food.name,
                            calories: nutrition.calories,
                            protein: nutrition.protein,
                            carbs: nutrition.carbs,
                            fats: nutrition.fats,
                            fiber: nutrition.fiber,
                            sugar: nutrition.sugar,
                            sodium: nutrition.sodium
                        )
                    }
                } label: {
                    Text("More")
                        .font(AppTheme.Typography.caption)
                        .foregroundStyle(AppTheme.Colors.primary)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.md) {
                    ForEach(viewModel.pinnedFoods) { food in
                        QuickAddChip(food: food) {
                            pendingFoodItem = food
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.xs)
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
            // Avatar
            Circle()
                .fill(Color(.systemGray6))
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(.systemGray3))
                )
            
            // Greeting & Name
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(AppTheme.Colors.textSecondary)
                
                Text("Profile")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(AppTheme.Colors.textPrimary)
            }
            
            Spacer()
            
            // Notification Bell
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    
                    // Red notification dot
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning!"
        case 12..<17:
            return "Good afternoon!"
        case 17..<21:
            return "Good evening!"
        default:
            return "Good night!"
        }
    }
    
    // MARK: - Macro Section
    private var macroSection: some View {
        NutriCard {
            VStack(spacing: AppTheme.Spacing.lg) {
                Text("Macronutrients")
                    .font(AppTheme.Typography.title2)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: AppTheme.Spacing.md) {
                    MacroProgressRow(
                        label: "Protein",
                        current: viewModel.summary?.totalNutrition.protein ?? 0,
                        goal: viewModel.summary?.goal.protein ?? 50,
                        unit: "g",
                        color: AppTheme.Colors.protein
                    )
                    
                    MacroProgressRow(
                        label: "Carbs",
                        current: viewModel.summary?.totalNutrition.carbs ?? 0,
                        goal: viewModel.summary?.goal.carbs ?? 250,
                        unit: "g",
                        color: AppTheme.Colors.carbs
                    )
                    
                    MacroProgressRow(
                        label: "Fats",
                        current: viewModel.summary?.totalNutrition.fats ?? 0,
                        goal: viewModel.summary?.goal.fats ?? 65,
                        unit: "g",
                        color: AppTheme.Colors.fats
                    )
                }
            }
        }
    }
    
    // MARK: - Log Section
    private var logSection: some View {
        NutriCard {
            VStack(spacing: AppTheme.Spacing.lg) {
                HStack {
                    Text("📋 Today's Log")
                        .font(AppTheme.Typography.title2)
                        .foregroundStyle(AppTheme.Colors.textPrimary)
                    
                    Spacer()
                    
                    if let count = viewModel.summary?.entries.count, count > 0 {
                        Text("\(count) items")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                    }
                }
                
                if let entries = viewModel.summary?.entries, !entries.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(entries.prefix(5)) { entry in
                            FoodLogRow(entry: entry) {
                                Task {
                                    await viewModel.deleteEntry(entry)
                                }
                            }
                            
                            if entry.id != entries.prefix(5).last?.id {
                                Divider()
                                    .padding(.leading, 56)
                            }
                        }
                    }
                    
                    if entries.count > 5 {
                        Button {
                            onNavigateToLog?()
                        } label: {
                            Text("See All \(entries.count) Entries")
                                .font(AppTheme.Typography.bodyMedium)
                                .foregroundStyle(AppTheme.Colors.primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, AppTheme.Spacing.sm)
                    }
                } else {
                    VStack(spacing: AppTheme.Spacing.md) {
                        Text("🍽️")
                            .font(.system(size: 48))
                        
                        Text("No food logged yet")
                            .font(AppTheme.Typography.body)
                            .foregroundStyle(AppTheme.Colors.textSecondary)
                        
                        Text("Tap the camera button below to get started")
                            .font(AppTheme.Typography.caption)
                            .foregroundStyle(AppTheme.Colors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, minHeight: 150)
                    .padding(.vertical, AppTheme.Spacing.xl)
                }
            }
        }
    }
}

// MARK: - Macro Progress Row Component
struct MacroProgressRow: View {
    let label: String
    let current: Double
    let goal: Double
    let unit: String
    let color: Color
    
    @State private var animatedProgress: Double = 0
    
    var progress: Double {
        min(current / goal, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(AppTheme.Typography.bodyMedium)
                    .foregroundStyle(AppTheme.Colors.textPrimary)
                
                Spacer()
                
                Text("\(Int(current))/\(Int(goal))\(unit)")
                    .font(AppTheme.Typography.caption)
                    .foregroundStyle(AppTheme.Colors.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color.opacity(0.15))
                        .frame(height: 12)
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: 6)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.8), color],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * animatedProgress, height: 12)
                        .animation(.easeInOut(duration: 1.0), value: animatedProgress)
                }
            }
            .frame(height: 12)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: current) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
    }
}

// MARK: - Quick Add Confirmation Sheet
struct QuickAddConfirmationSheet: View {
    @Environment(\.dismiss) private var dismiss
    let food: FoodItem
    let onConfirm: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.xl) {
                VStack(spacing: AppTheme.Spacing.md) {
                    Text(EmojiHelper.emoji(for: food.name))
                        .font(.system(size: 64))

                    Text(food.name)
                        .font(AppTheme.Typography.title2)
                        .fontWeight(.bold)

                    Text("\(Int(food.nutrition.calories)) kcal")
                        .font(AppTheme.Typography.title3)
                        .foregroundStyle(AppTheme.Colors.calories)

                    HStack(spacing: AppTheme.Spacing.md) {
                        macroBadge(label: "Protein", value: food.nutrition.protein, unit: "g", color: AppTheme.Colors.protein)
                        macroBadge(label: "Carbs", value: food.nutrition.carbs, unit: "g", color: AppTheme.Colors.carbs)
                        macroBadge(label: "Fats", value: food.nutrition.fats, unit: "g", color: AppTheme.Colors.fats)
                    }
                }
                .padding(.top, AppTheme.Spacing.xl)

                Spacer()

                VStack(spacing: AppTheme.Spacing.md) {
                    Button {
                        onConfirm()
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Add to Today's Log")
                        }
                        .primaryButton()
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .secondaryButton()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Confirm Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func macroBadge(label: String, value: Double, unit: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(Int(value))\(unit)")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 70)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [FoodEntryModel.self, NutritionGoalModel.self], inMemory: true)
}
