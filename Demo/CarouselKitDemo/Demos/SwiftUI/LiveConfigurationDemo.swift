import CarouselKit
import SwiftUI

/// Binds controls directly to a `CarouselConfiguration` held in `@State`.
struct LiveConfigurationDemo: View {
    var onSelect: (Destination) -> Void = { _ in }

    @State private var configuration = CarouselConfiguration(cardAspectRatio: 1.2)
    @State private var parallaxAmount: CGFloat = 40

    private var isAutoScrolling: Binding<Bool> {
        Binding(
            get: { configuration.autoScrollInterval != nil },
            set: { configuration.autoScrollInterval = $0 ? .seconds(3) : nil }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                EndlessCarousel(Destination.all, configuration: configuration) { destination in
                    Button { onSelect(destination) } label: {
                        DestinationPhotoCard(destination: destination, size: .compact, parallaxAmount: parallaxAmount)
                    }
                    .buttonStyle(.plain)
                }

                VStack(spacing: 20) {
                    ValueSlider(title: "Card width", value: $configuration.cardWidthRatio, range: 0.4...0.9, format: .percent)
                    ValueSlider(title: "Spacing", value: $configuration.spacing, range: 0...40, format: .points)
                    ValueSlider(title: "Side card scale", value: $configuration.inactiveScale, range: 0.7...1, format: .percent)
                    ValueSlider(title: "Parallax", value: $parallaxAmount, range: 0...80, format: .points)
                    Toggle("Auto-scroll", isOn: isAutoScrolling)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color(.systemGray6))
    }
}

private struct ValueSlider: View {
    enum Format {
        case percent
        case points

        func text(for value: CGFloat) -> String {
            switch self {
            case .percent: "\(Int((value * 100).rounded()))%"
            case .points: "\(Int(value.rounded())) pt"
            }
        }
    }

    let title: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let format: Format

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                Spacer()
                Text(format.text(for: value))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range) {
                Text(title)
            }
        }
    }
}

#Preview {
    LiveConfigurationDemo()
}
