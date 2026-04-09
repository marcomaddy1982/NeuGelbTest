import SwiftUI

extension Text {
    func titleStyle() -> some View {
        self.font(AppFonts.title)
    }
    
    func subtitleStyle() -> some View {
        self.font(AppFonts.subtitle)
    }
    
    func headlineStyle() -> some View {
        self.font(AppFonts.headline)
    }
    
    func bodyStyle() -> some View {
        self.font(AppFonts.body)
    }
    
    func labelStyle() -> some View {
        self.font(AppFonts.label)
    }
    
    func captionStyle() -> some View {
        self.font(AppFonts.caption)
    }
    
    func secondaryTextStyle() -> Text {
        self.foregroundColor(.secondary)
    }
}

extension Image {
    func largeIconStyle() -> some View {
        self.font(AppFonts.largeIcon)
    }
    
    func mediumIconStyle() -> some View {
        self.font(AppFonts.mediumIcon)
    }
    
    func smallIconStyle() -> some View {
        self.font(AppFonts.smallIcon)
    }
}
