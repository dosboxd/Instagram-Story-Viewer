import SwiftUI
import UIKit

struct StoryViewScreen: View {

    var viewModel: UserViewModel
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
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
