import CarouselKit
import SwiftUI

/// Carousels stacked in a vertical feed. Card photos drift sideways while a carousel is
/// swiped and up or down while the page scrolls.
struct VerticalParallaxDemo: View {
    var onSelect: (Destination) -> Void = { _ in }

    @State private var axes: ParallaxAxes = .both

    private let rows = ["Lakes & Mountains", "Forest Trails", "Sunrise Walks", "Weekend Escapes", "Hidden Gems"]

    private static let configuration = CarouselConfiguration(
        cardWidthRatio: 0.8,
        cardAspectRatio: 0.62,
        spacing: 12,
        inactiveScale: 0.94,
        inactiveOffsetY: 0,
        verticalInset: 16,
        autoScrollInterval: nil
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Picker("Parallax", selection: $axes) {
                    ForEach(ParallaxAxes.allCases) { option in
                        Text(option.title).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)

                Text("Scroll the page to see photos drift up and down; swipe a row to see them drift sideways.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)

                ForEach(Array(rows.enumerated()), id: \.offset) { index, title in
                    Text(title)
                        .font(.title3.bold())
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    EndlessCarousel(Self.destinations(startingAt: index), configuration: Self.configuration) { destination in
                        Button { onSelect(destination) } label: {
                            DestinationBannerCard(destination: destination, parallaxAxes: axes.value)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
    }

    /// Rotates the photos so each row starts with a different one.
    private static func destinations(startingAt offset: Int) -> [Destination] {
        let all = Destination.all
        let start = offset % all.count
        return Array(all[start...] + all[..<start])
    }
}

private enum ParallaxAxes: String, CaseIterable, Identifiable {
    case horizontal
    case vertical
    case both

    var id: Self { self }

    var title: String {
        switch self {
        case .horizontal: "Horizontal"
        case .vertical: "Vertical"
        case .both: "Both"
        }
    }

    var value: Axis.Set {
        switch self {
        case .horizontal: .horizontal
        case .vertical: .vertical
        case .both: [.horizontal, .vertical]
        }
    }
}

#Preview {
    VerticalParallaxDemo()
}
