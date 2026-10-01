import CarouselKit
import UIKit

final class CustomViewCardsViewController: DemoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let carousel = EndlessCarouselView(
            items: Destination.all,
            configuration: CarouselConfiguration(
                cardWidthRatio: 0.7,
                cardAspectRatio: 1.25,
                autoScrollInterval: .seconds(2.5)
            ),
            style: CarouselCardStyle(cornerRadius: 28, borderWidth: 0, shadowOpacity: 0.25, parallaxAmount: 30),
            background: { destination in
                TintedPhotoView(image: destination.image)
            },
            foreground: { destination in
                TripBadgesView(destination: destination)
            }
        )

        carousel.onSelect = { [weak self] destination in
            self?.showDetail(for: destination)
        }

        install(
            carousel,
            caption: "Both layers are custom UIView subclasses: a tinted photo that drifts with parallax, and badges that stay put."
        )
    }
}

/// Card background: the photo with a color tint and a dark fade at the bottom.
private final class TintedPhotoView: UIView {
    init(image: UIImage?) {
        super.init(frame: .zero)

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let tint = GradientView(
            colors: [
                UIColor.systemIndigo.withAlphaComponent(0.35),
                .clear,
                UIColor.black.withAlphaComponent(0.6)
            ],
            locations: [0, 0.45, 1]
        )

        for subview in [imageView, tint] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
            NSLayoutConstraint.activate([
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.topAnchor.constraint(equalTo: topAnchor),
                subview.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Card foreground: frosted duration and rating badges in the top corners and the title at the bottom.
private final class TripBadgesView: UIView {
    init(destination: Destination) {
        super.init(frame: .zero)

        let durationBadge = Self.badge(symbol: "clock.fill", text: destination.durationText.uppercased())
        let ratingBadge = Self.badge(
            symbol: "star.fill",
            text: destination.rating.formatted(.number.precision(.fractionLength(1)))
        )

        let titleLabel = UILabel()
        titleLabel.text = destination.title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8

        for subview in [durationBadge, ratingBadge, titleLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }

        NSLayoutConstraint.activate([
            durationBadge.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            durationBadge.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),

            ratingBadge.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            ratingBadge.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func badge(symbol: String, text: String) -> UIView {
        let font = UIFont.systemFont(ofSize: 13, weight: .semibold)

        let icon = UIImageView(image: UIImage(systemName: symbol, withConfiguration: UIImage.SymbolConfiguration(font: font)))
        icon.tintColor = .white

        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = .white

        let content = UIStackView(arrangedSubviews: [icon, label])
        content.spacing = 5
        content.alignment = .center

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blur.layer.cornerRadius = 14
        blur.layer.cornerCurve = .continuous
        blur.clipsToBounds = true

        content.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: blur.contentView.topAnchor, constant: 6),
            content.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor, constant: -6),
            content.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor, constant: 10),
            content.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor, constant: -10)
        ])
        return blur
    }
}
