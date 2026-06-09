import SwiftUI

struct LoginView: View {
    @State private var viewModel = LoginViewModelFactory.makeLoginViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "film.stack")
                .largeIconStyle()
                .foregroundStyle(AppColors.primary)
                .padding(.bottom, 8)

            Text("auth.title")
                .titleStyle()

            Text("auth.subtitle")
                .secondaryTextStyle()
                .bodyStyle()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            if case .error(let message) = viewModel.loginState {
                Text(message)
                    .captionStyle()
                    .foregroundStyle(AppColors.errorRed)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if viewModel.loginState == .loading {
                ProgressView()
                    .padding()
            } else {
                PrimaryActionButton(title: "auth.login") {
                    Task { await viewModel.login() }
                }
            }
        }
        .padding(.bottom, 48)
    }
}
