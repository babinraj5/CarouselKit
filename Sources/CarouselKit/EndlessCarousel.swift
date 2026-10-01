import SwiftUI

/// A horizontally paging carousel that loops endlessly in both directions,
/// centers the active card, and optionally auto-advances.
///
/// ```swift
/// EndlessCarousel(trips) { trip in
///     TripCard(trip: trip)
/// }
/// ```
public struct EndlessCarousel<Item: Identifiable, Content: View>: View {
    private let items: [Item]
    private let configuration: CarouselConfiguration
    private let content: (Item) -> Content
    private var pageChangeAction: ((_ index: Int, _ item: Item) -> Void)?

    @State private var containerWidth: CGFloat = 0
    @State private var position: Int?
    @State private var isUserScrolling = false
    @State private var pageTracker = PageTracker()

    public init(
        _ items: [Item],
        configuration: CarouselConfiguration = CarouselConfiguration(),
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.configuration = configuration
        self.content = content
    }

    /// Calls `action` whenever a different item becomes the centered card, whether the user
    /// swiped or the carousel auto-scrolled. Also called once for the first card when the
    /// carousel appears, and again after `items` change.
    ///
    /// ```swift
    /// EndlessCarousel(trips) { trip in
    ///     TripCard(trip: trip)
    /// }
    /// .onPageChange { index, trip in
    ///     currentPage = index
    /// }
    /// ```
    ///
    /// - Parameter action: Receives the item's index in `items` and the item itself.
    public func onPageChange(perform action: @escaping (_ index: Int, _ item: Item) -> Void) -> Self {
        var copy = self
        copy.pageChangeAction = action
        return copy
    }

    private var virtualCount: Int { items.count * configuration.repeatCount }
    private var startIndex: Int { (configuration.repeatCount / 2) * items.count }

    public var body: some View {
        let cardSize = configuration.cardSize(forContainerWidth: containerWidth)

        ZStack {
            if containerWidth > 0, !items.isEmpty {
                carousel(cardSize: cardSize)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: cardSize.height + configuration.verticalInset * 2)
        .background { WidthReader(width: $containerWidth) }
        // Restarts whenever the page changes or a swipe begins/ends, so the user never fights the timer.
        .task(id: AutoScrollState(position: position, isUserScrolling: isUserScrolling)) {
            await autoAdvance()
        }
        .onChange(of: position, initial: true) { _, newPosition in
            reportPageChange(for: newPosition)
        }
        .onChange(of: items.map(\.id)) {
            pageTracker.reset()
            reportPageChange(for: position)
        }
    }

    private func reportPageChange(for position: Int?) {
        guard
            let pageChangeAction,
            let index = pageTracker.pageChange(forPosition: position, itemCount: items.count)
        else { return }
        pageChangeAction(index, items[index])
    }

    private func carousel(cardSize: CGSize) -> some View {
        let inactiveScale = configuration.inactiveScale
        let inactiveOffsetY = configuration.inactiveOffsetY

        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: configuration.spacing) {
                ForEach(0..<virtualCount, id: \.self) { index in
                    content(items[index % items.count])
                        .frame(width: cardSize.width, height: cardSize.height)
                        .scrollTransition(axis: .horizontal) { view, phase in
                            view
                                .scaleEffect(phase.isIdentity ? 1 : inactiveScale)
                                .offset(y: phase.isIdentity ? 0 : inactiveOffsetY)
                        }
                }
            }
            .scrollTargetLayout()
            .padding(.vertical, configuration.verticalInset)
        }
        .contentMargins(.horizontal, (containerWidth - cardSize.width) / 2, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollPosition(id: $position, anchor: .center)
        .scrollClipDisabled()
        .modifier(UserScrollTracker(isUserScrolling: $isUserScrolling))
        .onAppear {
            if position == nil { position = startIndex }
        }
    }

    private func autoAdvance() async {
        guard
            let interval = configuration.autoScrollInterval,
            items.count > 1,
            !isUserScrolling,
            let current = position
        else { return }

        do {
            try await Task.sleep(for: interval)
        } catch {
            return
        }

        withAnimation(configuration.autoScrollAnimation) {
            position = current + 1
        }
    }
}

private struct AutoScrollState: Hashable {
    let position: Int?
    let isUserScrolling: Bool
}

private struct UserScrollTracker: ViewModifier {
    @Binding var isUserScrolling: Bool

    func body(content: Content) -> some View {
        if #available(iOS 18.0, macOS 15.0, *) {
            content.onScrollPhaseChange { _, phase in
                isUserScrolling = phase == .tracking || phase == .interacting || phase == .decelerating
            }
        } else {
            content
        }
    }
}

private struct WidthReader: View {
    @Binding var width: CGFloat

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear { width = proxy.size.width }
                .onChange(of: proxy.size.width) { _, newWidth in width = newWidth }
        }
    }
}

#Preview {
    struct Sample: Identifiable {
        let id: Int
        let color: Color
    }

    let samples = [Color.orange, .pink, .purple, .blue, .teal].enumerated().map { Sample(id: $0.offset, color: $0.element) }

    return EndlessCarousel(samples) { sample in
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(sample.color.gradient)
            .overlay(Text("\(sample.id + 1)").font(.largeTitle.bold()).foregroundStyle(.white))
    }
}
