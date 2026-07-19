import SwiftUI

public struct MetadataRowView: View {
    let label: LocalizedStringKey
    let value: String

    public init(label: LocalizedStringKey, value: String) {
        self.label = label
        self.value = value
    }

    public var body: some View {
        HStack {
            Text(label)
                .font(AppFonts.caption)
                .foregroundColor(.secondary)
            
            Divider()
            
            Text(value)
                .bodyStyle()
            
            Spacer()
        }
    }
}

#Preview {
    MetadataRowView(label: "Budget", value: "$100,000,000")
}
