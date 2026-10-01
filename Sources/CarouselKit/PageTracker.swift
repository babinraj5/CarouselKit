/// Maps the carousel's virtual scroll position (items repeated many times) back to an
/// index in the real items, and reports each page only once.
struct PageTracker: Equatable {
    private(set) var currentIndex: Int?

    /// Returns the new page index if the centered item changed, otherwise `nil`.
    mutating func pageChange(forPosition position: Int?, itemCount: Int) -> Int? {
        guard let position, position >= 0, itemCount > 0 else { return nil }
        let index = position % itemCount
        guard index != currentIndex else { return nil }
        currentIndex = index
        return index
    }

    /// Forgets the reported page so the next position is reported again, e.g. after the items change.
    mutating func reset() {
        currentIndex = nil
    }
}
