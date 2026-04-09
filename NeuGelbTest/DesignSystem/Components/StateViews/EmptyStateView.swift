import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .largeIconStyle()
                .foregroundColor(.gray)
            
            Text(title)
                .titleStyle()
            
            Text(message)
                .font(AppFonts.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyStateView(
        icon: "folder.fill",
        title: "No Results",
        message: "Try searching for something else"
    )
}
