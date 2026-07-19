import SwiftUI

public struct TagBadge: View {
    let text: String

    public init(text: String) {
        self.text = text
    }

    public var body: some View {
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
