import SwiftUI

struct TagBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .captionStyle()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(AppColors.backgroundNeutral)
            .cornerRadius(16)
    }
}

#Preview {
    TagBadge(text: "Action")
}
