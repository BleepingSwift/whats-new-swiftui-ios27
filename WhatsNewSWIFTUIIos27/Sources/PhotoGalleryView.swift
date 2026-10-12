import SwiftUI

@available(iOS 27, *)
struct PhotoGalleryView: View {
    private static let imageSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 64 * 1024 * 1024,
            diskCapacity: 256 * 1024 * 1024
        )
        return URLSession(configuration: configuration)
    }()

    let photos = Photo.samples

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(photos) { photo in
                    AsyncImage(request: URLRequest(url: photo.url, cachePolicy: .returnCacheDataElseLoad)) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    }
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding()
        }
        .asyncImageURLSession(Self.imageSession)
        .navigationTitle("Cached Images")
    }
}

#Preview {
    if #available(iOS 27, *) {
        NavigationStack {
            PhotoGalleryView()
        }
    }
}