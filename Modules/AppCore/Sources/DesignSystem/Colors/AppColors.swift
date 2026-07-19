import SwiftUI

public struct AppColors {
    // Primary colors
    public static let primary = Color.blue
    public static let primaryDark = Color("primaryDark")

    // Accent colors
    public static let accent = Color.orange
    public static let accentSecondary = Color("accentSecondary")

    // State colors
    public static let errorRed = Color.red
    public static let successGreen = Color.green
    public static let warningOrange = Color.orange

    // Neutral colors (backgrounds, cards)
    public static let backgroundLight = Color("backgroundLight")
    public static let backgroundNeutral = Color("backgroundNeutral")
    public static let divider = Color("divider")

    // Text colors
    public static let textPrimary = Color("textPrimary")
    public static let textSecondary = Color.secondary

    // Custom accent for ratings/highlights
    public static let ratingGold = Color("ratingGold")
}
