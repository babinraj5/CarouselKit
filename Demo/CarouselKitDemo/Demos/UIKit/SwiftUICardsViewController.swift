import CarouselKit
import UIKit

final class SwiftUICardsViewController: DemoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let carousel = EndlessCarouselView(
            items: Destination.all,
            configuration: CarouselConfiguration(
                cardWidthRatio: 0.85,
                cardAspectRatio: 0.62,
                spacing: 12,
                inactiveScale: 0.94,
                inactiveOffsetY: 0
            )
        ) { destination in
            DestinationBannerCard(destination: destination)
        }

        carousel.onSelect = { [weak self] destination in
            self?.showDetail(for: destination)
        }

        install(carousel, caption: "The cards are a SwiftUI view; the carousel is still a UIView in this UIKit screen.")
    }
}
