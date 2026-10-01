# CarouselKit

![Made with Swift 6](https://img.shields.io/badge/Made%20with-Swift%206-F05138?logo=swift&logoColor=white)
![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)

An endless, auto-scrolling card carousel for SwiftUI and UIKit.

- Loops forever in both directions and snaps one card per swipe
- Side cards shrink slightly; the centered card stands out
- Optional auto-scroll and a parallax effect for images
- Tells you which card is showing, for page dots or analytics

**Made with Swift 6**, with full data-race safety checks turned on. **Requires** iOS 17+ (or macOS 14+) and Xcode 16+.

---

## Installation

In Xcode, choose **File → Add Package Dependencies…**, then either:

- click **Add Local…** and select the `CarouselKit` folder, or
- paste the package's git URL.

Then add `import CarouselKit` where you use it.

---

## SwiftUI

### Basic carousel

Pass any array of `Identifiable` items and build a view for each card:

```swift
EndlessCarousel(places) { place in
    Image(place.imageName)
        .resizable()
        .scaledToFill()
        .clipShape(RoundedRectangle(cornerRadius: 24))
}
```

The carousel sizes the cards for you, so your card view should fill the space it's given.

### Handling taps

Wrap the card in a `Button`:

```swift
EndlessCarousel(places) { place in
    Button { selectedPlace = place } label: {
        PlaceCard(place: place)
    }
    .buttonStyle(.plain)
}
```

### Knowing which card is showing

`.onPageChange` is called whenever a new card slides into the center, including when the carousel first appears:

```swift
EndlessCarousel(places) { place in
    PlaceCard(place: place)
}
.onPageChange { index, place in
    currentPage = index              // 0 ..< places.count
    analytics.log("viewed", place.id)
}
```

### Parallax

Add `.scrollParallax()` to an image so it drifts inside its card while scrolling. The card must clip the image:

```swift
EndlessCarousel(places) { place in
    Color.clear
        .overlay {
            Image(place.imageName)
                .resizable()
                .scaledToFill()
                .scrollParallax(amount: 40)   // 20 is subtle, 60 is strong
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
}
```

---

## Configuration

Every setting has a default, so only pass the ones you want to change:

```swift
EndlessCarousel(places, configuration: CarouselConfiguration(
    cardWidthRatio: 0.75,
    autoScrollInterval: nil   // turn off auto-scroll
)) { place in
    PlaceCard(place: place)
}
```

| Setting | Default | What it does |
|---|---|---|
| `cardWidthRatio` | `0.6` | Card width as a share of the carousel width |
| `cardAspectRatio` | `1.43` | Card height ÷ width (above 1 = portrait, below 1 = landscape) |
| `spacing` | `14` | Gap between cards |
| `inactiveScale` | `0.9` | Size of side cards (`1` = no shrinking) |
| `inactiveOffsetY` | `6` | How far side cards move down (`0` = none) |
| `verticalInset` | `30` | Space above and below the cards for shadows |
| `autoScrollInterval` | `.seconds(3)` | Time between auto slides (`nil` = off) |
| `autoScrollAnimation` | `.smooth(duration: 1.0)` | Animation for auto slides |

The carousel's height is worked out from these settings, so you don't need to set it.

To reuse a setup across screens, make it a preset:

```swift
extension CarouselConfiguration {
    static let banner = CarouselConfiguration(cardWidthRatio: 0.85, cardAspectRatio: 0.55)
}

EndlessCarousel(promos, configuration: .banner) { promo in PromoCard(promo: promo) }
```

---

## UIKit

`EndlessCarouselView` is a regular `UIView` with the same features.

### Basic carousel

```swift
let carousel = EndlessCarouselView(items: trips) { trip in
    UIImage(named: trip.imageName)
} foreground: { trip in
    TripLabelView(trip: trip)   // optional view drawn on top of the image
}

carousel.onSelect = { [weak self] trip in
    self?.showDetails(for: trip)
}

carousel.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(carousel)
NSLayoutConstraint.activate([
    carousel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    carousel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    carousel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

Pin only the sides and a vertical position. The view sets its own height.

### Other kinds of cards

```swift
// Any UIView as the card (it gets the parallax effect)
EndlessCarouselView(items: products, background: { product in
    ProductBackgroundView(product: product)
})

// A SwiftUI view as the card
EndlessCarouselView(items: trips) { trip in
    TripCard(trip: trip)
}
```

Card views are display-only. Use `onSelect` for taps.

### Card style

Image and custom-view cards get a white border, rounded corners and a shadow. Change them with `CarouselCardStyle`:

```swift
EndlessCarouselView(
    items: trips,
    style: CarouselCardStyle(cornerRadius: 20, borderWidth: 0, shadowOpacity: 0.1, parallaxAmount: 25)
) { trip in
    UIImage(named: trip.imageName)
}
```

### Knowing which card is showing

```swift
carousel.onPageChange = { [weak pageControl] index, trip in
    pageControl?.currentPage = index
}
```

`carousel.currentIndex` also holds the index of the centered card.

### Updating

You can change `items`, `configuration`, `onSelect` and `onPageChange` at any time, for example after a network request:

```swift
carousel.items = newTrips
```

In table or collection view cells, create the carousel once per cell and just update `items` when the cell is reused.

---

## Tips

- **Resize large photos.** Images around 1200 px wide scroll smoothly; 3000+ px photos can stutter.
- **Use fixed IDs.** Don't create a new `UUID()` for an item every time you load the data.
- **Empty arrays are fine.** The carousel shows nothing until your data arrives.

---

## Demo app

Open `Demo/CarouselKitDemo.xcodeproj` and run it on a simulator. It shows every SwiftUI and UIKit option in this README.

---

## Running the tests

```bash
swift test
```

Or open `Package.swift` in Xcode and press **⌘U**.
