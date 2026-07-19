import SwiftUI

extension Text {
    public func titleStyle() -> some View {
        self.font(AppFonts.title)
    }

    public func subtitleStyle() -> some View {
        self.font(AppFonts.subtitle)
    }

    public func headlineStyle() -> some View {
        self.font(AppFonts.headline)
    }

    public func bodyStyle() -> some View {
        self.font(AppFonts.body)
    }

    public func labelStyle() -> some View {
        self.font(AppFonts.label)
    }

    public func captionStyle() -> some View {
        self.font(AppFonts.caption)
    }

    public func secondaryTextStyle() -> Text {
        self.foregroundColor(.secondary)
    }
}

extension Image {
    public func largeIconStyle() -> some View {
        self.font(AppFonts.largeIcon)
    }

    public func mediumIconStyle() -> some View {
        self.font(AppFonts.mediumIcon)
    }

    public func smallIconStyle() -> some View {
        self.font(AppFonts.smallIcon)
    }
}
