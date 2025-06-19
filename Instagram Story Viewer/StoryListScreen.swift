import SwiftUI

struct UserViewModel {
    let id: Int
    let name: String
    let picture: UIImage
}

struct StoryListScreen: View {

    @State private var users: [User] = []
    @State private var userViewModels: [UserViewModel] = []

    var body: some View {
        VStack {
            Text("Instagram")
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(userViewModels, id: \UserViewModel.id) {
                        StoryCell(viewModel: $0)
                    }
                }
            }
            .frame(height: 128)
            .background(Color.pink)
            Spacer()
        }
        .padding()
        .onAppear {
            let url = Bundle.main.url(forResource: "users", withExtension: "json")
            let contents = FileManager.default.contents(atPath: url!.relativePath)
            let decoded = try? JSONDecoder().decode(Root.self, from: contents!)
            self.users = decoded?.pages.flatMap { $0.users } ?? []

            Task {
                try await withThrowingTaskGroup(of: UserViewModel?.self, returning: Void.self) { group in
                    for user in users {
                        guard let url = URL(string: user.profile_picture_url) else { continue }
                        group.addTask {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            return UserViewModel(id: user.id, name: user.name, picture: UIImage(data: data)!)
                        }
                    }

                    var images: [UserViewModel] = []
                    // Adding only non-nil images to the array
                    for try await image in group {
                        if let image = image {
                            images.append(image)
                        }
                    }

                    self.userViewModels = images
                }
            }
        }
    }
}

#Preview {
    StoryListScreen()
}

func downloadImage(from url: URL) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw ImageError.invalidData
    }
    return image
}

enum ImageError: Error {
    case invalidData
}

