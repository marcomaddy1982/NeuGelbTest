import SwiftUI

struct ErrorStateView<Content: View>: View {
    let errorMessage: String
    let onRetry: () async -> Void
    let retryButtonTitle: String
    @ViewBuilder let additionalContent: () -> Content
    
    init(
        errorMessage: String,
        retryButtonTitle: String = "Try Again",
        onRetry: @escaping () async -> Void,
        @ViewBuilder additionalContent: @escaping () -> Content = { EmptyView() }
    ) {
        self.errorMessage = errorMessage
        self.retryButtonTitle = retryButtonTitle
        self.onRetry = onRetry
        self.additionalContent = additionalContent
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .largeIconStyle()
                .foregroundColor(AppColors.errorRed)
            
            Text("Error")
                .titleStyle()
            
            Text(errorMessage)
                .font(AppFonts.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            PrimaryActionButton(title: retryButtonTitle) {
                Task {
                    await onRetry()
                }
            }
            
            additionalContent()
        }
    }
}

#Preview {
    ErrorStateView(
        errorMessage: "Failed to load data",
        onRetry: {
            print("Retry tapped")
        }
    )
}
