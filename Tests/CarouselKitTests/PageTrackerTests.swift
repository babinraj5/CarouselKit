import Testing
@testable import CarouselKit

struct PageTrackerTests {
    @Test func reportsTheFirstPosition() {
        var tracker = PageTracker()

        #expect(tracker.pageChange(forPosition: 3000, itemCount: 6) == 0)
        #expect(tracker.currentIndex == 0)
    }

    @Test(arguments: [(3001, 1), (3005, 5), (3006, 0), (2999, 5)])
    func mapsVirtualPositionsToItemIndexes(position: Int, expectedIndex: Int) {
        var tracker = PageTracker()

        #expect(tracker.pageChange(forPosition: position, itemCount: 6) == expectedIndex)
    }

    @Test func doesNotReportTheSamePageTwice() {
        var tracker = PageTracker()
        _ = tracker.pageChange(forPosition: 3001, itemCount: 6)

        #expect(tracker.pageChange(forPosition: 3001, itemCount: 6) == nil)
        #expect(tracker.pageChange(forPosition: 3007, itemCount: 6) == nil, "Same item one loop later")
    }

    @Test func reportsAgainAfterReset() {
        var tracker = PageTracker()
        _ = tracker.pageChange(forPosition: 3001, itemCount: 6)

        tracker.reset()

        #expect(tracker.pageChange(forPosition: 3001, itemCount: 6) == 1)
    }

    @Test func ignoresMissingPositionsAndEmptyItems() {
        var tracker = PageTracker()

        #expect(tracker.pageChange(forPosition: nil, itemCount: 6) == nil)
        #expect(tracker.pageChange(forPosition: 4, itemCount: 0) == nil)
        #expect(tracker.currentIndex == nil)
    }
}
