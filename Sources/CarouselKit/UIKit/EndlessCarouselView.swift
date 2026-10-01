#if canImport(UIKit)
import SwiftUI
import UIKit

/// A UIKit view that displays an ``EndlessCarousel``.
///
/// Pin its leading, trailing, and top (or bottom) edges; its height follows its width
/// through a constraint derived from ``configuration`` (priority 999, so an explicit
/// height constraint can override it).
///
/// ```swift
/// let carousel = EndlessCarouselView(items: trips) { trip in
///     UIImage(named: trip.imageName)
/// }
/// carousel.onSelect = { trip in print(trip.title) }
/// carousel.onPageChange = { index, trip in pageControl.currentPage = index }
/// ```
@MainActor
public final class EndlessCarouselView<Item: Identifiable>: UIView {
    public var items: [Item] {
        didSet { reloadCarousel() }
    }

    public var configuration: CarouselConfiguration {
        didSet {
            reloadCarousel()
            updateHeightConstraint()
        }
    }

    /// Called when the user taps a card.
    public var onSelect: ((Item) -> Void)?

    /// Called whenever a different item becomes the centered card, with its index in ``items``.
    /// Also called once for the first card when the carousel appears, and again after ``items`` change.
    public var onPageChange: ((_ index: Int, _ item: Item) -> Void)?

    /// Index in ``items`` of the centered card, or `nil` before the carousel first appears.
    public private(set) var currentIndex: Int?

    private let makeCard: (Item) -> AnyView
    private let hostingController = UIHostingController(rootView: AnyView(EmptyView()))
    private var heightConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    /// Creates a carousel whose cards are SwiftUI views.
    public init<Content: View>(
        items: [Item],
        configuration: CarouselConfiguration = CarouselConfiguration(),
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.configuration = configuration
        self.makeCard = { AnyView(content($0)) }
        super.init(frame: .zero)
        embedHostingView()
        updateHeightConstraint()
        reloadCarousel()
    }

    /// Creates a carousel whose cards are UIKit views.
    ///
    /// - Parameters:
    ///   - background: Fills the card and drifts with the parallax effect, for example a `UIImageView`.
    ///   - foreground: Optional view drawn on top that stays still, for example labels.
    ///
    /// Card views are display-only; handle taps with ``onSelect``.
    public convenience init(
        items: [Item],
        configuration: CarouselConfiguration = CarouselConfiguration(),
        style: CarouselCardStyle = CarouselCardStyle(),
        background: @escaping (Item) -> UIView,
        foreground: ((Item) -> UIView)? = nil
    ) {
        self.init(items: items, configuration: configuration) { item in
            UIKitCard(
                style: style,
                makeBackground: { background(item) },
                makeForeground: foreground.map { makeView in { makeView(item) } }
            )
        }
    }

    /// Creates a carousel whose cards show an image, with an optional overlay view.
    public convenience init(
        items: [Item],
        configuration: CarouselConfiguration = CarouselConfiguration(),
        style: CarouselCardStyle = CarouselCardStyle(),
        image: @escaping (Item) -> UIImage?,
        foreground: ((Item) -> UIView)? = nil
    ) {
        self.init(
            items: items,
            configuration: configuration,
            style: style,
            background: { item in
                let imageView = UIImageView(image: image(item))
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                return imageView
            },
            foreground: foreground
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("EndlessCarouselView must be created in code.")
    }

    // MARK: - Private

    /// Expressed as a constraint rather than `intrinsicContentSize` so Auto Layout can solve it
    /// before the view has a width, e.g. when a table view measures a self-sizing cell.
    private func updateHeightConstraint() {
        heightConstraint?.isActive = false
        let constraint = heightAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: configuration.cardWidthRatio * configuration.cardAspectRatio,
            constant: configuration.verticalInset * 2
        )
        constraint.priority = .required - 1
        constraint.isActive = true
        heightConstraint = constraint
    }

    private func embedHostingView() {
        hostingController.safeAreaRegions = []
        let hostedView: UIView = hostingController.view
        hostedView.backgroundColor = .clear
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostedView)
        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func reloadCarousel() {
        let makeCard = makeCard
        hostingController.rootView = AnyView(
            EndlessCarousel(items, configuration: configuration) { [weak self] item in
                Button { self?.onSelect?(item) } label: {
                    makeCard(item)
                }
                .buttonStyle(.plain)
            }
            .onPageChange { [weak self] index, item in
                self?.currentIndex = index
                self?.onPageChange?(index, item)
            }
        )
    }
}

// MARK: - UIKit card

private struct UIKitCard: View {
    let style: CarouselCardStyle
    let makeBackground: () -> UIView
    let makeForeground: (() -> UIView)?

    var body: some View {
        let outerShape = RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
        let innerShape = RoundedRectangle(cornerRadius: max(style.cornerRadius - style.borderWidth, 0), style: .continuous)

        Color.clear
            .overlay {
                HostedUIView(make: makeBackground)
                    .scrollParallax(amount: style.parallaxAmount)
            }
            .overlay {
                if let makeForeground {
                    HostedUIView(make: makeForeground)
                }
            }
            .clipShape(innerShape)
            .padding(style.borderWidth)
            .background {
                outerShape
                    .fill(Color(uiColor: style.borderColor))
                    .shadow(color: .black.opacity(style.shadowOpacity), radius: 20, y: 14)
            }
            .contentShape(outerShape)
    }
}

/// Embeds a UIKit view that always takes the size SwiftUI proposes, ignoring its intrinsic size.
private struct HostedUIView: UIViewRepresentable {
    let make: () -> UIView

    func makeUIView(context: Context) -> UIView {
        let view = make()
        // Lets taps and swipes reach the carousel instead of the card's views.
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIView, context: Context) -> CGSize? {
        proposal.replacingUnspecifiedDimensions()
    }
}
#endif
