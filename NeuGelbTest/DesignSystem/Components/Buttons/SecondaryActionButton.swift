import SwiftUI

struct SecondaryActionButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(AppColors.primary)
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColors.primary, lineWidth: 1.5)
                )
        }
    }
}

#Preview {
    SecondaryActionButton(title: "Create an account") {
        print("Button tapped")
    }
    .padding()
}
