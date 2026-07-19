import SwiftUI

public struct AppFonts {
    // Heading styles
    public static let title    = Font.system(.title, design: .default).weight(.bold)
    public static let subtitle = Font.system(.title2, design: .default).weight(.semibold)
    public static let headline = Font.system(.headline, design: .default)

    // Body styles
    public static let body    = Font.system(.body, design: .default)
    public static let label   = Font.system(.subheadline, design: .default).weight(.semibold)
    public static let caption = Font.system(.caption, design: .default)

    // Icon styles — preserve exact sizes at default, scale proportionally
    public static let largeIcon  = Font.custom("", size: 48, relativeTo: .largeTitle)
    public static let mediumIcon = Font.custom("", size: 36, relativeTo: .title)
    public static let smallIcon  = Font.custom("", size: 24, relativeTo: .title2)
}
