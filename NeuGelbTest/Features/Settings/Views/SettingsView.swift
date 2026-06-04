import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingsViewModelFactory.makeSettingsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            Form {
                appearanceSection
                defaultTabSection
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
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
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

    // MARK: - Sections

    private var appearanceSection: some View {
        Section(LocalizedStringKey("settings.section.appearance")) {
            Picker(LocalizedStringKey("settings.section.appearance"), selection: $viewModel.appearanceMode) {
                ForEach(AppearanceMode.allCases, id: \.self) { mode in
                    Text(mode.label).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }

    private var defaultTabSection: some View {
        Section(LocalizedStringKey("settings.section.defaultTab")) {
            Picker(LocalizedStringKey("settings.section.defaultTab"), selection: $viewModel.defaultTab) {
                ForEach(DefaultTab.allCases, id: \.self) { tab in
                    Text(tab.label).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }

    private var cacheSection: some View {
        Section(LocalizedStringKey("settings.section.cache")) {
            Button(role: .destructive) {
                viewModel.requestClearCache()
            } label: {
                Label(LocalizedStringKey("settings.cache.clear"), systemImage: "trash")
            }

            Text("settings.cache.description")
                .font(AppFonts.caption)
                .foregroundColor(.secondary)

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

    private var aboutSection: some View {
        Section(LocalizedStringKey("settings.section.about")) {
            LabeledContent(LocalizedStringKey("settings.about.version")) {
                Text(viewModel.appVersion)
                    .foregroundColor(.secondary)
            }

            LabeledContent(LocalizedStringKey("settings.about.dataSource")) {
                Text("TMDB")
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
