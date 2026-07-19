import AppFeatures
import Foundation
import Observation
import SwiftUI

@Observable
final class SettingsViewModel {
    @ObservationIgnored @AppStorage("appearanceMode") var appearanceMode: AppearanceMode = .system
    @ObservationIgnored @AppStorage("defaultTab") var defaultTab: DefaultTab = .discover

    var showClearCacheConfirmation: Bool = false
    var isCacheCleared: Bool = false
    var cacheItemCount: Int = 0
    var currentDefaultTab: DefaultTab = .discover

    private let imageCache: ImageCaching

    init(imageCache: ImageCaching) {
        self.imageCache = imageCache
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    func loadCacheCount() async {
        cacheItemCount = await imageCache.count()
    }

    func refreshDefaultTab() {
        currentDefaultTab = defaultTab
    }

    func requestClearCache() {
        showClearCacheConfirmation = true
    }

    func clearCache() async {
        await imageCache.removeAll()
        cacheItemCount = 0
        isCacheCleared = true
    }
}
