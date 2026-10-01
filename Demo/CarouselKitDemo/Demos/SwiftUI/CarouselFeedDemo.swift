import CarouselKit
import SwiftUI

extension CarouselConfiguration {
    /// Wide landscape banners that auto-advance.
    static let banner = CarouselConfiguration(
        cardWidthRatio: 0.85,
        cardAspectRatio: 0.55,
        spacing: 12,
        inactiveScale: 0.94,
        inactiveOffsetY: 0,
        verticalInset: 20,
        autoScrollInterval: .seconds(4)
    )

    /// Portrait cards with neighbors visible on both sides.
    static let gallery = CarouselConfiguration(
        cardWidthRatio: 0.5,
        cardAspectRatio: 1.35,
        spacing: 12,
        inactiveScale: 0.92,
        inactiveOffsetY: 4,
        verticalInset: 20,
        autoScrollInterval: nil
    )

    /// Small square tiles, several visible at once.
    static let compact = CarouselConfiguration(
        cardWidthRatio: 0.32,
        cardAspectRatio: 1,
        spacing: 10,
        inactiveScale: 0.9,
        inactiveOffsetY: 0,
        verticalInset: 16,
        autoScrollInterval: nil
    )
}

/// Several carousels in a vertical feed, each using a reusable configuration preset.
struct CarouselFeedDemo: View {
    var onSelect: (Destination) -> Void = { _ in }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                FeedSectionHeader(title: "Featured", preset: ".banner")
                EndlessCarousel(Destination.all, configuration: .banner) { destination in
                    Button { onSelect(destination) } label: {
                        DestinationBannerCard(destination: destination)
                    }
                    .buttonStyle(.plain)
                }

                FeedSectionHeader(title: "Top Rated", preset: ".gallery")
                EndlessCarousel(Destination.all.filter { $0.rating >= 4.8 }, configuration: .gallery) { destination in
                    Button { onSelect(destination) } label: {
                        DestinationPhotoCard(destination: destination, size: .compact, parallaxAmount: 20)
                    }
                    .buttonStyle(.plain)
                }

                FeedSectionHeader(title: "Browse by Mood", preset: ".compact, any SwiftUI view")
                EndlessCarousel(Mood.all, configuration: .compact) { mood in
                    MoodTile(mood: mood)
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }
}

private struct FeedSectionHeader: View {
    let title: String
    let preset: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title3.bold())
            Spacer()
            Text(preset)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

private struct Mood: Identifiable {
    let id: String
    let name: String
    let symbolName: String
    let color: Color

    static let all = [
        Mood(id: "calm", name: "Calm", symbolName: "water.waves", color: .teal),
        Mood(id: "adventure", name: "Adventure", symbolName: "figure.hiking", color: .orange),
        Mood(id: "forest", name: "Forest", symbolName: "leaf.fill", color: .green),
        Mood(id: "sunrise", name: "Sunrise", symbolName: "sunrise.fill", color: .pink),
        Mood(id: "night", name: "Night", symbolName: "moon.stars.fill", color: .indigo)
    ]
}

private struct MoodTile: View {
    let mood: Mood

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: mood.symbolName)
                .font(.title)
            Text(mood.name)
                .font(.footnote.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(mood.color.gradient, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    CarouselFeedDemo()
}
