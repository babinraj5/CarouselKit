import SwiftUI

private struct ScrollParallax: ViewModifier {
    let amount: CGFloat
    let axes: Axis.Set

    func body(content: Content) -> some View {
        let horizontalAmount = axes.contains(.horizontal) ? amount : 0
        let verticalAmount = axes.contains(.vertical) ? amount : 0

        // Measuring a clear container rather than `content` keeps the motion relative to the
        // card's size; a scaled-to-fill image reports a size larger than the card.
        Color.clear
            .overlay {
                content
                    .padding(.horizontal, -horizontalAmount)
                    .padding(.vertical, -verticalAmount)
            }
            .scrollTransition(axis: .horizontal) { view, phase in
                view.offset(x: -phase.value * horizontalAmount)
            }
            // `scrollTransition` only tracks the nearest scroll view, which for a card is the
            // horizontal carousel, so vertical motion is measured against the nearest
            // vertically scrolling ancestor instead.
            .visualEffect { view, proxy in
                view.offset(y: -Self.verticalProgress(proxy) * verticalAmount)
            }
    }

    /// Where the view sits in the nearest vertical scroll view: `-1` just above the visible
    /// area, `0` centered, `1` just below it. `0` when there is no vertical scroll view.
    nonisolated private static func verticalProgress(_ proxy: GeometryProxy) -> CGFloat {
        guard let visibleArea = proxy.bounds(of: .scrollView(axis: .vertical)) else { return 0 }
        let height = proxy.size.height
        let distance = height / 2 - visibleArea.midY
        let range = (visibleArea.height + height) / 2
        guard range > 0 else { return 0 }
        return min(max(distance / range, -1), 1)
    }
}

extension View {
    /// Shifts the view as it moves through a scroll view, so it appears to drift inside its container.
    ///
    /// The result fills the space it's given, and the view is enlarged by `amount` on each side
    /// along `axes` so its edges stay hidden, so the container must clip it.
    ///
    /// - Parameters:
    ///   - amount: The maximum shift in points.
    ///   - axes: `.horizontal` reacts to the carousel's scrolling. `.vertical` reacts to an
    ///     enclosing vertical SwiftUI `ScrollView`, for example a feed of carousels.
    public func scrollParallax(amount: CGFloat = 40, axes: Axis.Set = .horizontal) -> some View {
        modifier(ScrollParallax(amount: amount, axes: axes))
    }
}
