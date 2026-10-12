import SwiftUI

struct Flashcard: Identifiable, Hashable {
    let id = UUID()
    var front: String
    var back: String
    var color: Color

    static let samples: [Flashcard] = [
        Flashcard(front: "struct", back: "A value type", color: .blue),
        Flashcard(front: "class", back: "A reference type", color: .purple),
        Flashcard(front: "enum", back: "A type with cases", color: .orange),
        Flashcard(front: "actor", back: "Isolated mutable state", color: .green),
        Flashcard(front: "protocol", back: "A blueprint of requirements", color: .pink),
        Flashcard(front: "macro", back: "Code that writes code", color: .teal),
        Flashcard(front: "async", back: "Can suspend", color: .indigo),
        Flashcard(front: "some", back: "An opaque type", color: .red)
    ]
}

struct Deck: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var cardCount: Int

    static let samples: [Deck] = [
        Deck(name: "Swift Basics", cardCount: 42),
        Deck(name: "SwiftUI Modifiers", cardCount: 28),
        Deck(name: "Concurrency", cardCount: 17),
        Deck(name: "Xcode Shortcuts", cardCount: 35)
    ]
}

struct Photo: Identifiable, Hashable {
    let id: Int
    var url: URL { URL(string: "https://picsum.photos/id/\(id)/600/400")! }

    static let samples: [Photo] = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19].map(Photo.init(id:))
}