import SwiftUI

private struct ScrollParallax: ViewModifier {
    let amount: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, -amount)
            .scrollTransition(axis: .horizontal) { view, phase in
                view.offset(x: -phase.value * amount)
            }
    }
}

extension View {
    /// Shifts the view horizontally as it moves through a horizontal scroll view.
    ///
    /// The view is widened by `amount` on each side so its edges stay hidden, so it
    /// must fill its proposed size and be clipped by its container.
    public func scrollParallax(amount: CGFloat = 40) -> some View {
        modifier(ScrollParallax(amount: amount))
    }
}
