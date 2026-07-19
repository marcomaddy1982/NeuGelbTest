import AppFeatures
import DesignSystem
import SwiftUI

struct SettingsView: View {
    var viewModel: SettingsViewModel
    @State private var authViewModel = AuthViewModelFactory.makeAuthViewModel()
    @Environment(SettingsRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
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

    // MARK: - Sections

    private var accountSection: some View {
        Section(LocalizedStringKey("settings.section.account")) {
            switch authViewModel.state {
            case .loggedOut:
                Text("settings.account.loggedOut")
                    .foregroundColor(.secondary)
                    .font(AppFonts.caption)

            case .loading:
                HStack {
                    ProgressView()
                    Text("settings.account.loading")
                        .foregroundColor(.secondary)
                        .font(AppFonts.caption)
                }

            case .loggedIn:
                accountProfileCard()
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
            }
        }
    }

    private func accountProfileCard() -> some View {
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

                Image(systemName: "person.fill")
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

            Button {
                router.navigate(to: .defaultTabPicker)
            } label: {
                HStack(spacing: 12) {
                    iconBadge(systemName: "star.fill", color: AppColors.primary)
                    Text(LocalizedStringKey("settings.section.defaultTab"))
                    Spacer()
                    Text(viewModel.currentDefaultTab.label)
                        .foregroundColor(.secondary)
                        .font(AppFonts.body)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .foregroundColor(.primary)
            }
        }
    }

    private var cacheSection: some View {
        Button {
            router.navigate(to: .cacheDetail)
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
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .foregroundColor(.primary)
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

#Preview {
    SettingsSheet()
}
