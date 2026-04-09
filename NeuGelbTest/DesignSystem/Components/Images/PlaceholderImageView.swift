import SwiftUI

struct PlaceholderImageView: View {
    let height: CGFloat
    let imageName: String
    let iconSize: CGFloat
    let iconColor: Color
    
    init(
        height: CGFloat = 200,
        imageName: String = "film.fill",
        iconSize: CGFloat = 48,
        iconColor: Color = .gray
    ) {
        self.height = height
        self.imageName = imageName
        self.iconSize = iconSize
        self.iconColor = iconColor
    }
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: iconSize))
                .foregroundColor(iconColor)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .background(AppColors.backgroundNeutral)
    }
}

#Preview {
    VStack(spacing: 16) {
        PlaceholderImageView()
        PlaceholderImageView(height: 140, imageName: "star.fill", iconColor: .orange)
    }
}
