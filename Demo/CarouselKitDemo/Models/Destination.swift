import UIKit

struct Destination: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let imageResource: ImageResource
    let durationInDays: Int
    let rating: Double

    var image: UIImage { UIImage(resource: imageResource) }

    var durationText: String {
        durationInDays == 1 ? "1 day" : "\(durationInDays) days"
    }

    var ratingText: String {
        "\(rating.formatted(.number.precision(.fractionLength(1))))/5"
    }
}

extension Destination {
    static let all: [Destination] = [
        Destination(id: "misty-lake", title: "Misty Lake Escape", imageResource: .mistyLake, durationInDays: 3, rating: 4.8),
        Destination(id: "golden-pines", title: "Golden Pine Walk", imageResource: .goldenPines, durationInDays: 1, rating: 4.7),
        Destination(id: "deep-forest", title: "Spend a Day in the Forest", imageResource: .deepForest, durationInDays: 2, rating: 4.9),
        Destination(id: "morning-rays", title: "Morning Rays Hike", imageResource: .morningRays, durationInDays: 1, rating: 4.6),
        Destination(id: "hidden-bridge", title: "Hidden Bridge Trail", imageResource: .hiddenBridge, durationInDays: 2, rating: 4.9),
        Destination(id: "lakeside-road", title: "Lakeside Road Trip", imageResource: .lakesideRoad, durationInDays: 4, rating: 4.8)
    ]
}
