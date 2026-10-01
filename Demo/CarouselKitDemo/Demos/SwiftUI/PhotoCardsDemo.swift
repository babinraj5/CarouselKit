import CarouselKit
import SwiftUI

/// The simplest SwiftUI usage: pass the items and build each card.
struct PhotoCardsDemo: View {
    var onSelect: (Destination) -> Void = { _ in }

    @State private var currentPage = 0

    private let destinations = Destination.all

    var body: some View {
        VStack(spacing: 12) {
            EndlessCarousel(destinations) { destination in
                Button { onSelect(destination) } label: {
                    DestinationPhotoCard(destination: destination)
                }
                .buttonStyle(.plain)
            }
            .onPageChange { index, _ in
                withAnimation(.snappy) { currentPage = index }
            }

            PageDots(count: destinations.count, currentPage: currentPage)

            Text("Item \(currentPage + 1) of \(destinations.count): \(destinations[currentPage].title)")
                .font(.subheadline.weight(.medium))
                .contentTransition(.numericText())

            Text("EndlessCarousel with a SwiftUI card. The dots follow .onPageChange as you swipe or it auto-scrolls.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}

private struct PageDots: View {
    let count: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.primary : Color.secondary.opacity(0.35))
                    .frame(width: index == currentPage ? 22 : 8, height: 8)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Page \(currentPage + 1) of \(count)")
    }
}

#Preview {
    PhotoCardsDemo()
}
