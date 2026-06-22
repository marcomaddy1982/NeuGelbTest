import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModelFactory.makeSettingsViewModel()
    @State private var authViewModel = AuthViewModelFactory.makeAuthViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Form {
                accountSection
                preferencesSection
                cacheSection
                aboutSection
            }
            .preferredColorScheme(viewModel.appearanceMode.colorScheme)
            .navigationTitle("settings.navigationTitle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .onAppear { viewModel.refreshDefaultTab() }
            .task { await viewModel.loadCacheCount() }
        }
    }

    // MARK: - Sections

    private var accountSection: some View {
        Section(LocalizedStringKey("settings.section.account")) {
            switch authViewModel.state {
            case .loggedOut:
                Button(LocalizedStringKey("settings.account.login")) {
                    Task { await authViewModel.login() }
                }

            case .loading:
                HStack {
                    ProgressView()
                    Text("settings.account.loading")
                        .foregroundColor(.secondary)
                        .font(AppFonts.caption)
                }

            case .loggedIn(let sessionId):
                accountProfileCard(sessionId: sessionId)
                Button(LocalizedStringKey("settings.account.logout"), role: .destructive) {
                    Task { await authViewModel.logout() }
                }

            case .error(let message):
                Label {
                    Text(message)
                } icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
                .font(AppFonts.caption)
                Button(LocalizedStringKey("settings.account.retry")) {
                    Task { await authViewModel.login() }
                }
            }
        }
    }

    private func accountProfileCard(sessionId: String) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)

                Text(String(sessionId.prefix(2)).uppercased())
                    .font(AppFonts.label)
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey("settings.account.session"))
                    .font(AppFonts.label)
                    .foregroundColor(.primary)

                HStack(spacing: 4) {
                    Circle()
                        .fill(AppColors.successGreen)
                        .frame(width: 7, height: 7)
                    Text("settings.account.sessionActive")
                        .font(AppFonts.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private var preferencesSection: some View {
        @Bindable var viewModel = viewModel
        return Section(LocalizedStringKey("settings.section.preferences")) {
            HStack(spacing: 12) {
                iconBadge(systemName: "circle.lefthalf.filled", color: .purple)
                Picker(LocalizedStringKey("settings.section.appearance"), selection: $viewModel.appearanceMode) {
                    ForEach(AppearanceMode.allCases, id: \.self) { mode in
                        Text(mode.label).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            NavigationLink {
                DefaultTabPickerView(selectedTab: $viewModel.defaultTab)
            } label: {
                HStack(spacing: 12) {
                    iconBadge(systemName: "star.fill", color: AppColors.primary)
                    Text(LocalizedStringKey("settings.section.defaultTab"))
                    Spacer()
                    Text(viewModel.currentDefaultTab.label)
                        .foregroundColor(.secondary)
                        .font(AppFonts.body)
                }
            }
        }
    }

    private var cacheSection: some View {
        NavigationLink {
            CacheDetailView(viewModel: viewModel)
        } label: {
            HStack(spacing: 12) {
                iconBadge(systemName: "internaldrive", color: .orange)
                Text(LocalizedStringKey("settings.section.cache"))
                Spacer()
                Text(viewModel.cacheItemCount == 0
                     ? String(localized: "settings.cache.empty")
                     : String(format: String(localized: "settings.cache.itemCount"), viewModel.cacheItemCount))
                    .foregroundColor(.secondary)
                    .font(AppFonts.caption)
            }
        }
    }

    private var aboutSection: some View {
        Section(LocalizedStringKey("settings.section.about")) {
            HStack(spacing: 12) {
                iconBadge(systemName: "info.circle.fill", color: Color(.systemGray))
                LabeledContent(LocalizedStringKey("settings.about.version")) {
                    Text(viewModel.appVersion)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 12) {
                iconBadge(systemName: "film.fill", color: AppColors.successGreen)
                LabeledContent(LocalizedStringKey("settings.about.dataSource")) {
                    Text("TMDB")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Helpers

    private func iconBadge(systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: 28, height: 28)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}

// MARK: - Default Tab Picker

private struct DefaultTabPickerView: View {
    @Binding var selectedTab: DefaultTab
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            ForEach(DefaultTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                    dismiss()
                } label: {
                    HStack {
                        Text(tab.label)
                            .foregroundColor(.primary)
                        Spacer()
                        if tab == selectedTab {
                            Image(systemName: "checkmark")
                                .foregroundColor(AppColors.primary)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
        .navigationTitle(LocalizedStringKey("settings.section.defaultTab"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Cache Detail

private struct CacheDetailView: View {
    var viewModel: SettingsViewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section {
                HStack {
                    Text(LocalizedStringKey("settings.cache.itemCountLabel"))
                    Spacer()
                    Text(viewModel.cacheItemCount == 0
                         ? String(localized: "settings.cache.empty")
                         : String(format: String(localized: "settings.cache.itemCount"), viewModel.cacheItemCount))
                        .foregroundColor(.secondary)
                }

                Text("settings.cache.description")
                    .font(AppFonts.caption)
                    .foregroundColor(.secondary)
            }

            Section {
                Button(role: .destructive) {
                    viewModel.requestClearCache()
                } label: {
                    Label(LocalizedStringKey("settings.cache.clear"), systemImage: "trash")
                }

                if viewModel.isCacheCleared {
                    Label {
                        Text("settings.cache.cleared")
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColors.successGreen)
                    }
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.successGreen)
                }
            }
        }
        .navigationTitle(LocalizedStringKey("settings.section.cache"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            LocalizedStringKey("settings.cache.confirmTitle"),
            isPresented: $viewModel.showClearCacheConfirmation
        ) {
            Button(LocalizedStringKey("settings.cache.confirmButton"), role: .destructive) {
                Task { await viewModel.clearCache() }
            }
            Button("common.cancel", role: .cancel) {}
        } message: {
            Text("settings.cache.confirmMessage")
        }
    }
}

#Preview {
    SettingsView()
}
