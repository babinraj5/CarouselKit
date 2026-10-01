import UIKit

final class DestinationDetailViewController: UIViewController {
    private let destination: Destination

    init(destination: Destination) {
        self.destination = destination
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let imageView = UIImageView(image: destination.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.text = destination.title
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle).bold()
        titleLabel.numberOfLines = 0

        let detailsLabel = UILabel()
        detailsLabel.text = "\(destination.durationText) · \(destination.ratingText)"
        detailsLabel.font = .preferredFont(forTextStyle: .headline)
        detailsLabel.textColor = .secondaryLabel

        let bodyLabel = UILabel()
        bodyLabel.text = "This screen was pushed from the carousel's onSelect callback, the same way you'd navigate from any UIKit control."
        bodyLabel.font = .preferredFont(forTextStyle: .body)
        bodyLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [titleLabel, detailsLabel, bodyLabel])
        textStack.axis = .vertical
        textStack.spacing = 8
        textStack.setCustomSpacing(16, after: detailsLabel)

        for subview in [imageView, textStack] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            textStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

private extension UIFont {
    func bold() -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
