import SwiftUI

public struct PlaceholderImageView: View {

    public enum Size {
        case small   // movie card thumbnail
        case large   // detail backdrop

        var baseHeight: CGFloat {
            switch self {
            case .small: return 140
            case .large: return 200
            }
        }

        var baseIconSize: CGFloat {
            switch self {
            case .small: return 36
            case .large: return 48
            }
        }

        var relativeTextStyle: Font.TextStyle {
            switch self {
            case .small: return .title
            case .large: return .largeTitle
            }
        }
    }

    let size: Size
    let imageName: String
    let iconColor: Color

    @ScaledMetric private var scaledHeight: CGFloat
    @ScaledMetric private var scaledIconSize: CGFloat

    public init(
        size: Size = .large,
        imageName: String = "film.fill",
        iconColor: Color = .gray
    ) {
        self.size = size
        self.imageName = imageName
        self.iconColor = iconColor
        _scaledHeight = ScaledMetric(wrappedValue: size.baseHeight, relativeTo: size.relativeTextStyle)
        _scaledIconSize = ScaledMetric(wrappedValue: size.baseIconSize, relativeTo: size.relativeTextStyle)
    }

    public var body: some View {
        VStack {
            Image(systemName: imageName)
                .font(.system(size: scaledIconSize))
                .foregroundColor(iconColor)
        }
        .frame(height: scaledHeight)
        .frame(maxWidth: .infinity)
        .background(AppColors.backgroundNeutral)
    }
}

#Preview {
    VStack(spacing: 16) {
        PlaceholderImageView(size: .large)
        PlaceholderImageView(size: .small, imageName: "star.fill", iconColor: .orange)
    }
}
