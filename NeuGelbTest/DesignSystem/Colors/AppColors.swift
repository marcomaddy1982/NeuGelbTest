import SwiftUI

struct AppColors {
    // Primary colors
    static let primary = Color.blue
    static let primaryDark = Color(red: 0.0, green: 0.48, blue: 1.0)
    
    // Accent colors
    static let accent = Color.orange
    static let accentSecondary = Color(red: 1.0, green: 0.58, blue: 0.0)
    
    // State colors
    static let errorRed = Color.red
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    
    // Neutral colors (backgrounds, cards)
    static let backgroundLight = Color(.sRGB, red: 0.98, green: 0.98, blue: 0.98)
    static let backgroundNeutral = Color(.sRGB, red: 0.95, green: 0.95, blue: 0.97)
    static let divider = Color(.sRGB, red: 0.92, green: 0.92, blue: 0.92)
    
    // Text colors
    static let textPrimary = Color.black
    static let textSecondary = Color.secondary
    
    // Custom accent for ratings/highlights
    static let ratingGold = Color(red: 1.0, green: 0.84, blue: 0.0)
}
