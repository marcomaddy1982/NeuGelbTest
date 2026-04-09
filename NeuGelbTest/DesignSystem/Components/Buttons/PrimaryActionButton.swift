import SwiftUI

struct PrimaryActionButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .background(AppColors.primary)
                .cornerRadius(8)
        }
    }
}

#Preview {
    PrimaryActionButton(title: "Try Again") {
        print("Button tapped")
    }
}
