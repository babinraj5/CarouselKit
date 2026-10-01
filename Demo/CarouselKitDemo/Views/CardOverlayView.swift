import UIKit

/// Title and trip details drawn over a card's photo, with a dark fade for legibility.
final class CardOverlayView: UIView {
    enum Size {
        case regular
        case compact

        var titleFontSize: CGFloat { self == .regular ? 24 : 17 }
        var detailFontSize: CGFloat { self == .regular ? 16 : 13 }
        var padding: CGFloat { self == .regular ? 18 : 12 }
    }

    init(destination: Destination, size: Size = .regular) {
        super.init(frame: .zero)

        let fade = GradientView(
            colors: [.clear, UIColor.black.withAlphaComponent(0.6)],
            locations: [0.4, 1]
        )

        let titleLabel = UILabel()
        titleLabel.text = destination.title
        titleLabel.font = .systemFont(ofSize: size.titleFontSize, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8

        let details = UIStackView(arrangedSubviews: [
            Self.detail(symbol: "clock.fill", text: destination.durationText, fontSize: size.detailFontSize),
            Self.detail(symbol: "star.fill", text: destination.ratingText, fontSize: size.detailFontSize)
        ])
        details.spacing = size == .regular ? 16 : 10

        let content = UIStackView(arrangedSubviews: [titleLabel, details])
        content.axis = .vertical
        content.alignment = .leading
        content.spacing = size == .regular ? 10 : 6

        for view in [fade, content] {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }

        NSLayoutConstraint.activate([
            fade.leadingAnchor.constraint(equalTo: leadingAnchor),
            fade.trailingAnchor.constraint(equalTo: trailingAnchor),
            fade.topAnchor.constraint(equalTo: topAnchor),
            fade.bottomAnchor.constraint(equalTo: bottomAnchor),

            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: size.padding),
            content.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -size.padding),
            content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -size.padding)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func detail(symbol: String, text: String, fontSize: CGFloat) -> UIView {
        let font = UIFont.systemFont(ofSize: fontSize, weight: .medium)

        let icon = UIImageView(image: UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(font: font)))
        icon.tintColor = .white

        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = .white

        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.spacing = 5
        stack.alpha = 0.85
        return stack
    }
}
