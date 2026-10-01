import CarouselKit
import SwiftUI

/// A landscape banner card written in SwiftUI, used to show SwiftUI cards inside a UIKit screen.
struct DestinationBannerCard: View {
    let destination: Destination
    var parallaxAxes: Axis.Set = .horizontal

    private let shape = RoundedRectangle(cornerRadius: 22, style: .continuous)

    var body: some View {
        Color.clear
            .overlay {
                Image(destination.imageResource)
                    .resizable()
                    .scaledToFill()
                    .scrollParallax(amount: 30, axes: parallaxAxes)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(destination.title)
                        .font(.headline)
                    Text("\(destination.durationText) · \(destination.ratingText)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .environment(\.colorScheme, .dark)
                .padding(12)
            }
            .clipShape(shape)
            .background {
                shape
                    .fill(.background)
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 8)
            }
    }
}
