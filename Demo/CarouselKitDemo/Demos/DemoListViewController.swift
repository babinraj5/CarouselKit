import SwiftUI
import UIKit

final class DemoListViewController: UITableViewController {
    private enum Section: CaseIterable {
        case swiftUI
        case uiKit

        var title: String {
            switch self {
            case .swiftUI: "SwiftUI"
            case .uiKit: "UIKit"
            }
        }

        var footer: String {
            switch self {
            case .swiftUI: "Pure SwiftUI screens using EndlessCarousel, the package's main API."
            case .uiKit: "UIKit screens using EndlessCarouselView, a UIView you can add with Auto Layout."
            }
        }

        var demos: [Demo] {
            switch self {
            case .swiftUI: [.swiftUIPhotoCards, .swiftUILiveConfiguration, .swiftUIFeed]
            case .uiKit: [.imageCards, .customViews, .swiftUICardsInUIKit, .playground, .tableCells]
            }
        }
    }

    private enum Demo {
        case swiftUIPhotoCards
        case swiftUILiveConfiguration
        case swiftUIFeed
        case imageCards
        case customViews
        case swiftUICardsInUIKit
        case playground
        case tableCells

        var title: String {
            switch self {
            case .swiftUIPhotoCards: "Photo Cards"
            case .swiftUILiveConfiguration: "Live Configuration"
            case .swiftUIFeed: "Carousel Feed"
            case .imageCards: "Image Cards"
            case .customViews: "Custom UIView Cards"
            case .swiftUICardsInUIKit: "SwiftUI Cards in UIKit"
            case .playground: "Configuration Playground"
            case .tableCells: "Carousels in Table Cells"
            }
        }

        var subtitle: String {
            switch self {
            case .swiftUIPhotoCards: "The basic EndlessCarousel with a SwiftUI card and parallax"
            case .swiftUILiveConfiguration: "Controls bound directly to a CarouselConfiguration in @State"
            case .swiftUIFeed: "Several carousels in a vertical feed using configuration presets"
            case .imageCards: "UIImage background with a UIKit overlay and parallax"
            case .customViews: "Your own UIView subclasses for the card layers, with a custom card style"
            case .swiftUICardsInUIKit: "SwiftUI card views hosted in a UIKit screen"
            case .playground: "Change the configuration live with sliders"
            case .tableCells: "Several carousels in self-sizing UITableView cells"
            }
        }

        var symbolName: String {
            switch self {
            case .swiftUIPhotoCards: "rectangle.portrait.on.rectangle.portrait"
            case .swiftUILiveConfiguration: "dial.medium"
            case .swiftUIFeed: "rectangle.grid.1x2"
            case .imageCards: "photo.on.rectangle"
            case .customViews: "square.stack.3d.up"
            case .swiftUICardsInUIKit: "swift"
            case .playground: "slider.horizontal.3"
            case .tableCells: "list.bullet.rectangle"
            }
        }

        @MainActor
        func makeViewController() -> UIViewController {
            switch self {
            case .swiftUIPhotoCards: Self.hosting { PhotoCardsDemo(onSelect: $0) }
            case .swiftUILiveConfiguration: Self.hosting { LiveConfigurationDemo(onSelect: $0) }
            case .swiftUIFeed: Self.hosting { CarouselFeedDemo(onSelect: $0) }
            case .imageCards: ImageCardsViewController()
            case .customViews: CustomViewCardsViewController()
            case .swiftUICardsInUIKit: SwiftUICardsViewController()
            case .playground: ConfigurationPlaygroundViewController()
            case .tableCells: TableViewCellsViewController()
            }
        }

        /// Wraps a SwiftUI demo so selecting a card pushes the shared UIKit detail screen.
        @MainActor
        private static func hosting<Content: View>(
            _ makeContent: (@escaping (Destination) -> Void) -> Content
        ) -> UIViewController {
            let host = UIHostingController(rootView: AnyView(EmptyView()))
            host.rootView = AnyView(makeContent { [weak host] destination in
                host?.showDetail(for: destination)
            })
            host.navigationItem.largeTitleDisplayMode = .never
            return host
        }
    }

    private let cellIdentifier = "DemoCell"

    init() {
        super.init(style: .insetGrouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CarouselKit"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    private func demo(at indexPath: IndexPath) -> Demo {
        Section.allCases[indexPath.section].demos[indexPath.row]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section.allCases[section].demos.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section.allCases[section].title
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        Section.allCases[section].footer
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let demo = demo(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        var content = UIListContentConfiguration.subtitleCell()
        content.text = demo.title
        content.secondaryText = demo.subtitle
        content.secondaryTextProperties.color = .secondaryLabel
        content.image = UIImage(systemName: demo.symbolName)
        content.textToSecondaryTextVerticalPadding = 4

        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let demo = demo(at: indexPath)
        let viewController = demo.makeViewController()
        viewController.title = demo.title
        navigationController?.pushViewController(viewController, animated: true)
    }
}
