import UIKit

enum AppError: Error {
    case noFileFound
}

actor NetworkLayer {

    var url: URL {
        Bundle.main.url(forResource: "users", withExtension: "json")!
    }

    func loadContentsOfFile(url: URL) throws -> Data {
        guard let contents = FileManager.default.contents(atPath: url.relativePath) else {
            throw AppError.noFileFound
        }
        return contents
    }

    func loadPages() async throws -> [Page] {
        let contents = try loadContentsOfFile(url: url)
        let decoded = try JSONDecoder().decode(Root.self, from: contents)
        return decoded.pages
    }

    func load(for users: [User]) async throws -> [UserViewModel] {
        return try await withThrowingTaskGroup(
            of: UserViewModel?.self, returning: [UserViewModel].self
        ) { group in
            for user in users {
                guard let url = URL(string: user.profile_picture_url) else {
                    print("Handle errors")
                    continue
                }

                group.addTask {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    return UserViewModel(
                        id: user.id, name: user.name, picture: UIImage(data: data)!, storyURL: url)
                }
            }

            var viewModels: [UserViewModel] = []
            for try await viewModel in group {
                if let viewModel {
                    viewModels.append(viewModel)
                }
            }
            return viewModels
        }
    }
}
