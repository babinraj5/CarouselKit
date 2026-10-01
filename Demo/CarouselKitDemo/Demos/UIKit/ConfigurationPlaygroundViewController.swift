import CarouselKit
import UIKit

final class ConfigurationPlaygroundViewController: DemoViewController {
    private let carousel = EndlessCarouselView(
        items: Destination.all,
        configuration: CarouselConfiguration(cardAspectRatio: 1.2)
    ) { destination in
        destination.image
    } foreground: { destination in
        CardOverlayView(destination: destination, size: .compact)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let controls = UIStackView(arrangedSubviews: [
            makeSliderRow(title: "Card width", range: 0.4...0.9, value: 0.6, format: Self.percent) { [weak self] value in
                self?.carousel.configuration.cardWidthRatio = CGFloat(value)
            },
            makeSliderRow(title: "Spacing", range: 0...40, value: 14, format: Self.points) { [weak self] value in
                self?.carousel.configuration.spacing = CGFloat(value)
            },
            makeSliderRow(title: "Side card scale", range: 0.7...1, value: 0.9, format: Self.percent) { [weak self] value in
                self?.carousel.configuration.inactiveScale = CGFloat(value)
            },
            makeSwitchRow(title: "Auto-scroll", isOn: true) { [weak self] isOn in
                self?.carousel.configuration.autoScrollInterval = isOn ? .seconds(3) : nil
            }
        ])
        controls.axis = .vertical
        controls.spacing = 20
        controls.isLayoutMarginsRelativeArrangement = true
        controls.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        controls.backgroundColor = .secondarySystemGroupedBackground
        controls.layer.cornerRadius = 16

        let controlsContainer = UIView()
        controls.translatesAutoresizingMaskIntoConstraints = false
        controlsContainer.addSubview(controls)
        NSLayoutConstraint.activate([
            controls.topAnchor.constraint(equalTo: controlsContainer.topAnchor),
            controls.bottomAnchor.constraint(equalTo: controlsContainer.bottomAnchor),
            controls.leadingAnchor.constraint(equalTo: controlsContainer.layoutMarginsGuide.leadingAnchor),
            controls.trailingAnchor.constraint(equalTo: controlsContainer.layoutMarginsGuide.trailingAnchor)
        ])

        let content = UIStackView(arrangedSubviews: [carousel, controlsContainer])
        content.axis = .vertical
        content.spacing = 8

        let scrollView = UIScrollView()
        for subview in [scrollView, content] {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(scrollView)
        scrollView.addSubview(content)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    // MARK: - Controls

    private static func percent(_ value: Float) -> String { "\(Int((value * 100).rounded()))%" }
    private static func points(_ value: Float) -> String { "\(Int(value.rounded())) pt" }

    private func makeSliderRow(
        title: String,
        range: ClosedRange<Float>,
        value: Float,
        format: @escaping @MainActor (Float) -> String,
        onChange: @escaping @MainActor (Float) -> Void
    ) -> UIView {
        let valueLabel = UILabel()
        valueLabel.text = format(value)
        valueLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .regular)
        valueLabel.textColor = .secondaryLabel

        let slider = UISlider()
        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound
        slider.value = value
        slider.addAction(UIAction { [weak valueLabel] action in
            guard let slider = action.sender as? UISlider else { return }
            valueLabel?.text = format(slider.value)
            onChange(slider.value)
        }, for: .valueChanged)

        let header = UIStackView(arrangedSubviews: [Self.titleLabel(title), valueLabel])
        let row = UIStackView(arrangedSubviews: [header, slider])
        row.axis = .vertical
        row.spacing = 8
        return row
    }

    private func makeSwitchRow(title: String, isOn: Bool, onChange: @escaping @MainActor (Bool) -> Void) -> UIView {
        let toggle = UISwitch()
        toggle.isOn = isOn
        toggle.addAction(UIAction { action in
            guard let toggle = action.sender as? UISwitch else { return }
            onChange(toggle.isOn)
        }, for: .valueChanged)

        return UIStackView(arrangedSubviews: [Self.titleLabel(title), toggle])
    }

    private static func titleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }
}
