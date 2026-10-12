import SwiftUI

@Observable
final class StudyProgress {
    private(set) var reviewed: [Flashcard] = []
    private var redoStack: [Flashcard] = []

    var remaining: [Flashcard] {
        Flashcard.samples.filter { card in !reviewed.contains { $0.id == card.id } }
    }

    var canUndo: Bool { !reviewed.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }

    var summary: String {
        "Reviewed \(reviewed.count) of \(Flashcard.samples.count) cards: "
            + reviewed.map(\.front).joined(separator: ", ")
    }

    func markReviewed(_ card: Flashcard) {
        reviewed.append(card)
        redoStack.removeAll()
    }

    func undo() {
        guard let last = reviewed.popLast() else { return }
        redoStack.append(last)
    }

    func redo() {
        guard let next = redoStack.popLast() else { return }
        reviewed.append(next)
    }

    func reset() {
        reviewed.removeAll()
        redoStack.removeAll()
    }
}

@available(iOS 27, *)
struct StudyToolbarView: View {
    @State private var progress = StudyProgress()

    var body: some View {
        List {
            Section("Tap a card to mark it reviewed") {
                ForEach(progress.remaining) { card in
                    Button {
                        progress.markReviewed(card)
                    } label: {
                        FlashcardRow(card: card)
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Reviewed") {
                ForEach(progress.reviewed) { card in
                    Text(card.front)
                        .font(.body.monospaced())
                }
            }
        }
        .navigationTitle("Study")
        .toolbar {
            ToolbarItemGroup {
                UndoButton()
                RedoButton()
            }
            .visibilityPriority(.high)

            ToolbarItem(placement: .topBarPinnedTrailing) {
                ShareButton()
            }

            ToolbarOverflowMenu {
                ExportButton()
                ResetProgressButton()
            }
        }
        .environment(progress)
    }
}

struct UndoButton: View {
    @Environment(StudyProgress.self) private var progress

    var body: some View {
        Button("Undo", systemImage: "arrow.uturn.backward") {
            progress.undo()
        }
        .disabled(!progress.canUndo)
    }
}

struct RedoButton: View {
    @Environment(StudyProgress.self) private var progress

    var body: some View {
        Button("Redo", systemImage: "arrow.uturn.forward") {
            progress.redo()
        }
        .disabled(!progress.canRedo)
    }
}

struct ShareButton: View {
    @Environment(StudyProgress.self) private var progress

    var body: some View {
        ShareLink(item: progress.summary) {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}

struct ExportButton: View {
    @Environment(StudyProgress.self) private var progress

    var body: some View {
        ShareLink(item: progress.reviewed.map { "\($0.front),\($0.back)" }.joined(separator: "\n")) {
            Label("Export as CSV", systemImage: "doc.text")
        }
    }
}

struct ResetProgressButton: View {
    @Environment(StudyProgress.self) private var progress

    var body: some View {
        Button("Reset Progress", systemImage: "arrow.counterclockwise", role: .destructive) {
            progress.reset()
        }
    }
}

#Preview {
    if #available(iOS 27, *) {
        NavigationStack {
            StudyToolbarView()
        }
    }
}