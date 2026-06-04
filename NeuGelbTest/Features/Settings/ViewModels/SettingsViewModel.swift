import Foundation
import SwiftUI
import Observation

@Observable
final class SettingsViewModel {
    @ObservationIgnored @AppStorage("appearanceMode") var appearanceMode: AppearanceMode = .system
    @ObservationIgnored @AppStorage("defaultTab") var defaultTab: DefaultTab = .discover

    var showClearCacheConfirmation: Bool = false
    var isCacheCleared: Bool = false

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
