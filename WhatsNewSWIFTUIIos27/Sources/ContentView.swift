import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 27, *) {
            DemoMenuView()
        } else {
            ContentUnavailableView(
                "Requires iOS 27",
                systemImage: "exclamationmark.triangle",
                description: Text("The SwiftUI APIs shown in this sample were introduced in iOS 27.")
            )
        }
    }
}

@available(iOS 27, *)
struct DemoMenuView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Reorder in a LazyVGrid") {
                    DeckGridView()
                }
                NavigationLink("Swipe Actions in a ScrollView") {
                    SwipeableDeckView()
                }
                NavigationLink("Cached AsyncImage") {
                    PhotoGalleryView()
                }
                NavigationLink("Confirmation Dialog with item:") {
                    DeckListView()
                }
                NavigationLink("Toolbar Overflow and Priority") {
                    StudyToolbarView()
                }
            }
            .navigationTitle("SwiftUI in iOS 27")
        }
    }
}

#Preview {
    ContentView()
}