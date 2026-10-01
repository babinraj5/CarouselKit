import CarouselKit
import UIKit

final class ImageCardsViewController: DemoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let carousel = EndlessCarouselView(items: Destination.all) { destination in
            destination.image
        } foreground: { destination in
            CardOverlayView(destination: destination)
        }

        let pageControl = UIPageControl()
        pageControl.numberOfPages = Destination.all.count
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .tertiaryLabel
        // The carousel can't be scrolled to a page programmatically, so the dots are display-only.
        pageControl.isUserInteractionEnabled = false

        carousel.onSelect = { [weak self] destination in
            self?.showDetail(for: destination)
        }
        carousel.onPageChange = { [weak pageControl] index, _ in
            pageControl?.currentPage = index
        }

        let stack = UIStackView(arrangedSubviews: [carousel, pageControl])
        stack.axis = .vertical
        install(stack, caption: "Swipe or wait for auto-scroll; the page control follows onPageChange. Tap a card to open it.")
    }
}
