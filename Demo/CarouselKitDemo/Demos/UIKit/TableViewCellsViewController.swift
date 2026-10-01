import CarouselKit
import UIKit

final class TableViewCellsViewController: UITableViewController {
    private struct Section {
        let title: String
        let destinations: [Destination]
    }

    private let sections = [
        Section(title: "Popular", destinations: Destination.all),
        Section(title: "Short Trips", destinations: Destination.all.filter { $0.durationInDays <= 2 }),
        Section(title: "Top Rated", destinations: Destination.all.filter { $0.rating >= 4.8 })
    ]

    init() {
        super.init(style: .plain)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(CarouselTableViewCell.self, forCellReuseIdentifier: CarouselTableViewCell.reuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CarouselTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! CarouselTableViewCell // Safe: registered in viewDidLoad.

        cell.configure(with: sections[indexPath.section].destinations) { [weak self] destination in
            self?.showDetail(for: destination)
        }
        return cell
    }
}

final class CarouselTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CarouselTableViewCell"

    // Created once per cell; reuse only swaps `items` and `onSelect`.
    private let carousel = EndlessCarouselView<Destination>(
        items: [],
        configuration: CarouselConfiguration(
            cardWidthRatio: 0.45,
            cardAspectRatio: 1.35,
            spacing: 12,
            inactiveScale: 0.95,
            inactiveOffsetY: 0,
            verticalInset: 16,
            autoScrollInterval: nil
        ),
        style: CarouselCardStyle(cornerRadius: 22, borderWidth: 3, shadowOpacity: 0.12, parallaxAmount: 20)
    ) { destination in
        destination.image
    } foreground: { destination in
        CardOverlayView(destination: destination, size: .compact)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        carousel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(carousel)

        let bottom = carousel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = .required - 1
        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: contentView.topAnchor),
            carousel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carousel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottom
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        carousel.onSelect = nil
    }

    func configure(with destinations: [Destination], onSelect: @escaping (Destination) -> Void) {
        carousel.items = destinations
        carousel.onSelect = onSelect
    }
}
