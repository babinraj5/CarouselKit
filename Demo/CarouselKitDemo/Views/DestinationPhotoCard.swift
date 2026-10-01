import CarouselKit
import SwiftUI

/// The portrait photo card from the Dribbble design, written in SwiftUI.
struct DestinationPhotoCard: View {
    enum Size {
        case regular
        case compact
    }

    let destination: Destination
    var size: Size = .regular
    var parallaxAmount: CGFloat = 40
    var parallaxAxes: Axis.Set = .horizontal

    private var borderWidth: CGFloat { size == .regular ? 5 : 3 }
    private var cornerRadius: CGFloat { size == .regular ? 30 : 22 }

    var body: some View {
        Color.clear
            .overlay {
                photoLayers
                    .scrollParallax(amount: parallaxAmount, axes: parallaxAxes)
            }
            .overlay {
                LinearGradient(colors: [.clear, .black.opacity(0.45)], startPoint: .center, endPoint: .bottom)
            }
            .overlay(alignment: .bottomLeading) { details }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius - borderWidth, style: .continuous))
            .padding(borderWidth)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.18), radius: size == .regular ? 20 : 12, y: size == .regular ? 14 : 8)
            }
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .accessibilityElement(children: .combine)
    }

    /// The photo with a blurred copy fading in toward the bottom behind the text.
    private var photoLayers: some View {
        Color.clear
            .overlay { photo }
            .overlay {
                photo
                    .blur(radius: 16, opaque: true)
                    .mask {
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.5),
                                .init(color: .black, location: 0.78)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
            }
            .accessibilityHidden(true)
    }

    private var photo: some View {
        Image(destination.imageResource)
            .resizable()
            .scaledToFill()
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: size == .regular ? 10 : 6) {
            Text(destination.title)
                .font(size == .regular ? .title2.bold() : .headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            HStack(spacing: size == .regular ? 16 : 10) {
                Label(destination.durationText, systemImage: "clock.fill")
                Label(destination.ratingText, systemImage: "star.fill")
            }
            .font(size == .regular ? .subheadline.weight(.medium) : .caption.weight(.medium))
            .opacity(0.85)
        }
        .foregroundStyle(.white)
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        .padding(size == .regular ? 18 : 12)
    }
}

#Preview {
    DestinationPhotoCard(destination: Destination.all[0])
        .frame(width: 240, height: 343)
        .padding(40)
        .background(Color(.systemGray6))
}
