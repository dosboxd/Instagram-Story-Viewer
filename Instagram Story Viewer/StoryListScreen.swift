import SwiftUI

struct UserViewModel: Identifiable {
    let id: Int
    let name: String
    let picture: UIImage
    let storyURL: URL
    var seen: Bool
    var liked: Bool = false

    init(id: Int, name: String, picture: UIImage, storyURL: URL) {
        self.id = id
        self.name = name
        self.picture = picture
        self.storyURL = storyURL
        self.seen = UserDefaults.standard.bool(forKey: "SEEN: \(id)")
        self.liked = UserDefaults.standard.bool(forKey: "LIKED: \(id)")
    }
}

struct StoryListScreen: View {

    @State private var users: [User] = []
    @State private var userViewModels: [UserViewModel] = []
    @State private var isPresented = false
    @State private var selection: UserViewModel?

    var body: some View {
        VStack {
            Text("Instagram")
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(userViewModels.indices, id: \.self) { index in
                        Button {
                            self.selection = userViewModels[index]
                            userViewModels[index].seen = true
                            UserDefaults.standard.set(
                                true, forKey: "SEEN: \(userViewModels[index].id)")
                            isPresented = true
                        } label: {
                            StoryCell(viewModel: userViewModels[index])
                                .sheet(item: $selection) { selection in
                                    StoryViewScreen(viewModel: selection) { isLiked in
                                        userViewModels[index].liked = isLiked
                                        UserDefaults.standard.set(isLiked, forKey: "LIKED: \(userViewModels[index].id)")
                                    }
                                }
                        }
                    }
                }
            }
            .frame(height: 128)
            .background(Color.pink)
            .padding(.bottom, 16)
            Button("Reset view state for all") {
                for i in userViewModels.indices {
                    UserDefaults.standard.set(false, forKey: "\(userViewModels[i].id)")
                    userViewModels[i].seen = false
                }
            }
            Spacer()
        }
        .padding()
        .onAppear {
            let url = Bundle.main.url(forResource: "users", withExtension: "json")
            let contents = FileManager.default.contents(atPath: url!.relativePath)
            let decoded = try? JSONDecoder().decode(Root.self, from: contents!)
            self.users = decoded?.pages.flatMap { $0.users } ?? []

            Task {
                try await withThrowingTaskGroup(of: UserViewModel?.self, returning: Void.self) {
                    group in
                    for user in users {
                        guard let url = URL(string: user.profile_picture_url) else { continue }
                        group.addTask {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            return UserViewModel(
                                id: user.id,
                                name: user.name,
                                picture: UIImage(data: data)!,
                                storyURL: url
                            )
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
