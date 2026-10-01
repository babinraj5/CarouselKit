import UIKit

/// Base screen for demos that show a single carousel with a caption underneath.
class DemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.largeTitleDisplayMode = .never
    }

    func install(_ carousel: UIView, caption: String) {
        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = .preferredFont(forTextStyle: .footnote)
        captionLabel.textColor = .secondaryLabel
        captionLabel.textAlignment = .center
        captionLabel.numberOfLines = 0

        for subview in [carousel, captionLabel] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }

        NSLayoutConstraint.activate([
            carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carousel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -20),

            captionLabel.topAnchor.constraint(equalTo: carousel.bottomAnchor, constant: 4),
            captionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            captionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

extension UIViewController {
    func showDetail(for destination: Destination) {
        navigationController?.pushViewController(DestinationDetailViewController(destination: destination), animated: true)
    }
}
