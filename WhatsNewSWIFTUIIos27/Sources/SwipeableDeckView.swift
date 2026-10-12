import SwiftUI

@available(iOS 27, *)
struct SwipeableDeckView: View {
    @State private var cards = Flashcard.samples

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(cards) { card in
                    FlashcardRow(card: card)
                        .swipeActions {
                            Button(role: .destructive) {
                                cards.removeAll { $0.id == card.id }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
        }
        .swipeActionsContainer()
        .overlay {
            if cards.isEmpty {
                ContentUnavailableView {
                    Label("No Cards", systemImage: "rectangle.stack")
                } actions: {
                    Button("Restore Cards") {
                        cards = Flashcard.samples
                    }
                }
            }
        }
        .navigationTitle("Swipe Actions")
    }
}

struct FlashcardRow: View {
    let card: Flashcard

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(card.color)
                .frame(width: 8)
            VStack(alignment: .leading) {
                Text(card.front)
                    .font(.headline.monospaced())
                Text(card.back)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(.background.secondary, in: .rect(cornerRadius: 12))
    }
}

#Preview {
    if #available(iOS 27, *) {
        NavigationStack {
            SwipeableDeckView()
        }
    }
}