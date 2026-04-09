import SwiftUI

struct MetadataRowView: View {
    let label: String
    let value: String
    
    var body: some View {
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
