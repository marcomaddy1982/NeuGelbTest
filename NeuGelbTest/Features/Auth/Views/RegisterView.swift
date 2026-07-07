import SwiftUI

struct RegisterView: View {
    @State private var viewModel = RegisterViewModelFactory.make()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                        .largeIconStyle()
                        .foregroundStyle(AppColors.primary)

                    Text("register.title")
                        .titleStyle()

                    Text("register.subtitle")
                        .secondaryTextStyle()
                        .bodyStyle()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 32)

                VStack(spacing: 16) {
                    TextField("register.field.name", text: $viewModel.name)
                        .formFieldStyle()
                        .textContentType(.name)
                        .autocorrectionDisabled()

                    TextField("register.field.email", text: $viewModel.email)
                        .formFieldStyle()
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    PasswordField(placeholder: "register.field.password", text: $viewModel.password)

                    PasswordField(placeholder: "register.field.confirmPassword", text: $viewModel.confirmPassword)

                    TextField("register.field.phoneNumber", text: $viewModel.phoneNumber)
                        .formFieldStyle()
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                .padding(.horizontal, 24)

                if case .error(let message) = viewModel.registerState {
                    Text(message)
                        .captionStyle()
                        .foregroundStyle(AppColors.errorRed)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                if viewModel.registerState == .loading {
                    ProgressView()
                        .padding()
                } else {
                    VStack {
                        PrimaryActionButton(title: "register.action") {
                            Task { await viewModel.register() }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .navigationTitle("register.navigationTitle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
