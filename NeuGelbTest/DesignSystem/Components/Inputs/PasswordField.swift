import SwiftUI

struct PasswordField: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @State private var isVisible: Bool = false

    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .textContentType(.password)
                } else {
                    SecureField(placeholder, text: $text)
                        .textContentType(.password)
                }
            }
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye.slash" : "eye")
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .formFieldStyle()
    }
}

#Preview {
    PasswordField(placeholder: "Password", text: .constant(""))
        .padding()
}
