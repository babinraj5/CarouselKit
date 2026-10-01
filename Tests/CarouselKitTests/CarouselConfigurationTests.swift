import CoreGraphics
import Testing
@testable import CarouselKit

struct CarouselConfigurationTests {
    @Test func cardSizeUsesWidthRatioAndAspectRatio() {
        let configuration = CarouselConfiguration(cardWidthRatio: 0.5, cardAspectRatio: 2)

        let size = configuration.cardSize(forContainerWidth: 400)

        #expect(size == CGSize(width: 200, height: 400))
    }

    @Test func cardSizeIsZeroBeforeLayout() {
        #expect(CarouselConfiguration().cardSize(forContainerWidth: 0) == .zero)
    }

    @Test func autoScrollCanBeDisabled() {
        #expect(CarouselConfiguration(autoScrollInterval: nil).autoScrollInterval == nil)
    }
}
