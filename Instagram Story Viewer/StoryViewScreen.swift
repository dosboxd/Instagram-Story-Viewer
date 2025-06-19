import SwiftUI
import UIKit

struct StoryViewScreen: View {

    var viewModels: [UserViewModel]
    @State var index: Int

    @State private var image: UIImage?
    var onLike: ((Bool, Int) -> Void)?
    var onSeen: ((Int) -> Void)?

    var body: some View {
        VStack {
            VStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
                HStack {
                    Button("Previous") {
                        if viewModels.indices.contains(index - 1) {
                            index -= 1
                            Task {
                                await loadImage()
                            }
                        }
                    }
                    Spacer()
                    Button(viewModels[index].liked ? "Remove Like" : "Like") {
                        onLike?(!viewModels[index].liked, index)
                    }
                    Spacer()
                    Button("Next") {
                        if viewModels.indices.contains(index + 1) {
                            index += 1
                            Task {
                                await loadImage()
                            }
                        }
                    }
                }
                .padding()
            }
        }.task {
            await loadImage()
        }
    }

    func loadImage() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: viewModels[index].storyURL)
            self.image = UIImage(data: data)
            onSeen?(index)
        } catch {
            print("Handle errors")
        }
    }
}
