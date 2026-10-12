import SwiftUI

@available(iOS 27, *)
struct DeckGridView: View {
    @State private var cards: [Flashcard]

    let columns = [GridItem(.adaptive(minimum: 120))]

    init(cards: [Flashcard] = Flashcard.samples) {
        self.cards = cards
    }

    var body: some View {
        ScrollView {
            Text("Long press a card, then drag it to a new spot.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top)

            LazyVGrid(columns: columns) {
                ForEach(cards) { card in
                    FlashcardView(card: card)
                }
                .reorderable()
            }
            .reorderContainer(for: Flashcard.self) { difference in
                apply(difference)
            }
            .padding()
        }
        .navigationTitle("Reorder")
    }
}

@available(iOS 27, *)
extension DeckGridView {
    func apply(_ difference: ReorderDifference<Flashcard.ID, ReorderableSingleCollectionIdentifier>) {
        var moved: [Flashcard] = []
        cards.removeAll { card in
            guard difference.sources.contains(card.id) else { return false }
            moved.append(card)
            return true
        }

        switch difference.destination.position {
        case .before(let id):
            let index = cards.firstIndex { $0.id == id } ?? cards.endIndex
            cards.insert(contentsOf: moved, at: index)
        case .end:
            cards.append(contentsOf: moved)
        }
    }
}

struct FlashcardView: View {
    let card: Flashcard

    var body: some View {
        VStack(spacing: 6) {
            Text(card.front)
                .font(.headline.monospaced())
            Text(card.back)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.85))
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(card.color.gradient, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    if #available(iOS 27, *) {
        NavigationStack {
            DeckGridView()
        }
    }
}