import SwiftUI

@available(iOS 27, *)
struct DeckListView: View {
    @State private var decks = Deck.samples
    @State private var deckToDelete: Deck?

    var body: some View {
        DeckList(decks: decks, deleteAction: { deckToDelete = $0 })
            .confirmationDialog("Delete deck?", item: $deckToDelete) { deck in
                Button("Delete \(deck.name)", role: .destructive) {
                    delete(deck)
                }
            } message: { deck in
                Text("\(deck.name) and its cards will be removed from all of your devices.")
            }
            .navigationTitle("Decks")
    }

    private func delete(_ deck: Deck) {
        decks.removeAll { $0.id == deck.id }
    }
}

struct DeckList: View {
    let decks: [Deck]
    let deleteAction: (Deck) -> Void

    var body: some View {
        List(decks) { deck in
            HStack {
                VStack(alignment: .leading) {
                    Text(deck.name)
                        .font(.headline)
                    Text("\(deck.cardCount) cards")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(role: .destructive) {
                    deleteAction(deck)
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    if #available(iOS 27, *) {
        NavigationStack {
            DeckListView()
        }
    }
}