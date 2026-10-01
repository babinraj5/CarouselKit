#if canImport(UIKit)
import UIKit

/// Appearance of cards built from UIKit views in ``EndlessCarouselView``.
public struct CarouselCardStyle {
    public var cornerRadius: CGFloat
    /// Width of the border drawn around the card. Use `0` for no border.
    public var borderWidth: CGFloat
    public var borderColor: UIColor
    /// Opacity of the drop shadow under the card. Use `0` for no shadow.
    public var shadowOpacity: CGFloat
    /// How far the background drifts while scrolling. Use `0` to disable parallax.
    public var parallaxAmount: CGFloat

    public init(
        cornerRadius: CGFloat = 30,
        borderWidth: CGFloat = 5,
        borderColor: UIColor = .white,
        shadowOpacity: CGFloat = 0.18,
        parallaxAmount: CGFloat = 40
    ) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.shadowOpacity = shadowOpacity
        self.parallaxAmount = parallaxAmount
    }
}
#endif
