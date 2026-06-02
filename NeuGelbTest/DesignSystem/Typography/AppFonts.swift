import SwiftUI

struct AppFonts {
    // Heading styles
    static let title    = Font.system(.title, design: .default).weight(.bold)
    static let subtitle = Font.system(.title2, design: .default).weight(.semibold)
    static let headline = Font.system(.headline, design: .default)

    // Body styles
    static let body    = Font.system(.body, design: .default)
    static let label   = Font.system(.subheadline, design: .default).weight(.semibold)
    static let caption = Font.system(.caption, design: .default)

    // Icon styles — preserve exact sizes at default, scale proportionally
    static let largeIcon  = Font.custom("", size: 48, relativeTo: .largeTitle)
    static let mediumIcon = Font.custom("", size: 36, relativeTo: .title)
    static let smallIcon  = Font.custom("", size: 24, relativeTo: .title2)
}
