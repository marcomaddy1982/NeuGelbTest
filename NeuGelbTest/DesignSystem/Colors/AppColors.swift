import SwiftUI

struct AppColors {
    // Primary colors
    static let primary = Color.blue
    static let primaryDark = Color("primaryDark")

    // Accent colors
    static let accent = Color.orange
    static let accentSecondary = Color("accentSecondary")

    // State colors
    static let errorRed = Color.red
    static let successGreen = Color.green
    static let warningOrange = Color.orange

    // Neutral colors (backgrounds, cards)
    static let backgroundLight = Color("backgroundLight")
    static let backgroundNeutral = Color("backgroundNeutral")
    static let divider = Color("divider")

    // Text colors
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color.secondary

    // Custom accent for ratings/highlights
    static let ratingGold = Color("ratingGold")
}
