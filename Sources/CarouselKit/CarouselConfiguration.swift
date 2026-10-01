import SwiftUI

/// Layout, appearance, and behavior settings for ``EndlessCarousel``.
public struct CarouselConfiguration: Sendable {
    /// Card width as a fraction of the carousel's width.
    public var cardWidthRatio: CGFloat
    /// Card height divided by card width.
    public var cardAspectRatio: CGFloat
    public var spacing: CGFloat
    /// Scale applied to cards that aren't centered.
    public var inactiveScale: CGFloat
    /// Vertical offset applied to cards that aren't centered.
    public var inactiveOffsetY: CGFloat
    /// Vertical room around the cards so shadows aren't clipped.
    public var verticalInset: CGFloat
    /// Set to `nil` to disable auto-scrolling.
    public var autoScrollInterval: Duration?
    public var autoScrollAnimation: Animation
    /// How many times the items are repeated to create the endless effect.
    public var repeatCount: Int

    public init(
        cardWidthRatio: CGFloat = 0.6,
        cardAspectRatio: CGFloat = 1.43,
        spacing: CGFloat = 14,
        inactiveScale: CGFloat = 0.9,
        inactiveOffsetY: CGFloat = 6,
        verticalInset: CGFloat = 30,
        autoScrollInterval: Duration? = .seconds(3),
        autoScrollAnimation: Animation = .smooth(duration: 1.0),
        repeatCount: Int = 1000
    ) {
        self.cardWidthRatio = cardWidthRatio
        self.cardAspectRatio = cardAspectRatio
        self.spacing = spacing
        self.inactiveScale = inactiveScale
        self.inactiveOffsetY = inactiveOffsetY
        self.verticalInset = verticalInset
        self.autoScrollInterval = autoScrollInterval
        self.autoScrollAnimation = autoScrollAnimation
        self.repeatCount = repeatCount
    }

    public func cardSize(forContainerWidth width: CGFloat) -> CGSize {
        let cardWidth = width * cardWidthRatio
        return CGSize(width: cardWidth, height: cardWidth * cardAspectRatio)
    }
}
