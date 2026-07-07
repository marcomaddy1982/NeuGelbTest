import SwiftUI

struct SettingsSheet: View {
    @State private var router = SettingsRouter()
    @State private var viewModel = SettingsViewModelFactory.makeSettingsViewModel()

    var body: some View {
        NavigationStack(path: $router.path) {
            SettingsView(viewModel: viewModel)
                .navigationDestination(for: SettingsRoute.self) { route in
                    switch route {
                    case .defaultTabPicker:
                        DefaultTabPickerView(viewModel: viewModel)
                    case .cacheDetail:
                        CacheDetailView(viewModel: viewModel)
                    }
                }
        }
        .environment(router)
    }
}

// MARK: - Default Tab Picker

struct DefaultTabPickerView: View {
    var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            ForEach(DefaultTab.allCases, id: \.self) { tab in
                Button {
                    viewModel.defaultTab = tab
                    dismiss()
                } label: {
                    HStack {
                        Text(tab.label)
                            .foregroundColor(.primary)
                        Spacer()
                        if tab == viewModel.defaultTab {
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

struct CacheDetailView: View {
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
    SettingsSheet()
}
