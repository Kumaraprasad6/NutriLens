import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: SearchViewModel
    @State private var showGroupFilter: Bool = false

    let onSelect: (IFCTFoodItem) -> Void

    init(onSelect: @escaping (IFCTFoodItem) -> Void) {
        self.onSelect = onSelect
        self._viewModel = State(initialValue: SearchViewModel())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBarSection
                groupFilterSection
                contentSection
            }
            .background(AppTheme.Colors.background)
            .navigationTitle("Search Indian Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            let service = IFCTDatabaseService(modelContext: modelContext)
            viewModel = SearchViewModel(databaseService: service)
            await viewModel.checkAndImport()
        }
        .sheet(isPresented: $viewModel.showDetailSheet) {
            if let food = viewModel.selectedFood {
                NutrientDetailSheet(
                    food: food,
                    onSelect: { selectedFood in
                        viewModel.showDetailSheet = false
                        onSelect(selectedFood)
                        dismiss()
                    }
                )
            }
        }
        .alert("Error", isPresented: .init(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var searchBarSection: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search Indian food...", text: $viewModel.searchQuery)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            await viewModel.search()
                        }
                    }

                if !viewModel.searchQuery.isEmpty {
                    Button(action: {
                        viewModel.clearSearch()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.vertical, AppTheme.Spacing.md)
    }

    private var groupFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Button(action: {
                    Task {
                        await viewModel.filterByGroup(nil)
                    }
                }) {
                    Text("All")
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(viewModel.selectedGroup == nil ? AppTheme.Colors.primary : Color(.systemGray6))
                        .foregroundColor(viewModel.selectedGroup == nil ? .white : .primary)
                        .clipShape(Capsule())
                }

                ForEach(viewModel.foodGroups, id: \.self) { group in
                    Button(action: {
                        Task {
                            await viewModel.filterByGroup(group)
                        }
                    }) {
                        Text(group)
                            .font(.system(size: 13, weight: .medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(viewModel.selectedGroup == group ? AppTheme.Colors.primary : Color(.systemGray6))
                            .foregroundColor(viewModel.selectedGroup == group ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }

    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isImporting {
            importLoadingView
        } else if viewModel.isLoading {
            loadingView
        } else if viewModel.searchResults.isEmpty && viewModel.searchQuery.isEmpty {
            emptySearchView
        } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
            noResultsView
        } else {
            resultsList
        }
    }

    private var importLoadingView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Importing Indian food database...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            Text("This happens only once")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var loadingView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            ProgressView()
            Text("Searching...")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptySearchView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            if !viewModel.recentSearches.isEmpty {
                recentSearchesSection
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Search for Indian foods")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text("Try \"Dal\", \"Rice\", \"Roti\" or \"Paneer\"")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var noResultsView: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 50))
                .foregroundColor(.secondary.opacity(0.5))
            Text("No results found")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.secondary)
            Text("Try a different search term")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var recentSearchesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Recent Searches")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                Button("Clear") {
                    viewModel.clearRecentSearches()
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.Colors.primary)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)

            ForEach(viewModel.recentSearches, id: \.self) { search in
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(.secondary)
                    Text(search)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        viewModel.removeRecentSearch(search)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.borderless)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.sm)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.searchQuery = search
                    Task {
                        await viewModel.search()
                    }
                }
            }
        }
    }

    private var resultsList: some View {
        List {
            ForEach(viewModel.searchResults) { food in
                SearchResultRow(food: food) {
                    viewModel.selectFood(food)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView { _ in }
}
