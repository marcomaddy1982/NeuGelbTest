import Foundation
import SwiftUI
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @AppStorage("appearanceMode") var appearanceMode: AppearanceMode = .system
    @AppStorage("defaultTab") var defaultTab: DefaultTab = .discover

    @Published var showClearCacheConfirmation: Bool = false
    @Published var isCacheCleared: Bool = false

    private let imageCache: ImageCaching

    init(imageCache: ImageCaching) {
        self.imageCache = imageCache
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    func requestClearCache() {
        showClearCacheConfirmation = true
    }

    func clearCache() async {
        await imageCache.removeAll()
        isCacheCleared = true
    }
}
