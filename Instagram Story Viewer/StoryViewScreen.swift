import SwiftUI
import UIKit

struct StoryViewScreen: View {

    var viewModel: UserViewModel
    @State private var image: UIImage? = nil
    var onLike: ((Bool) -> Void)?

    var body: some View {
        VStack {
            if let image {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    Button(viewModel.liked ? "Remove Like" : "Like") {
                        onLike?(!viewModel.liked)
                    }
                }
            } else {
                ProgressView()
            }
        }.task {
            if let dataResponse = try? await URLSession.shared.data(from: viewModel.storyURL) {
                self.image = UIImage(data: dataResponse.0)
            }
        }
    }
}
