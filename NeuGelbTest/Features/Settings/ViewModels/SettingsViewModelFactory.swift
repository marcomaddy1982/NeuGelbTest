import Foundation

@MainActor
final class SettingsViewModelFactory {
    @Injected<ImageCaching> var imageCache

    static func makeSettingsViewModel() -> SettingsViewModel {
        let factory = SettingsViewModelFactory()
        return SettingsViewModel(imageCache: factory.imageCache)
    }
}
