import SwiftUI

class StoryListScreenModel: ObservableObject {

    private let networkLayer = NetworkLayer()
    @MainActor @Published var userViewModels: [UserViewModel] = []
    var page: Int = 0

    func load() {
        Task.detached {
            do {
                let pages = try await self.networkLayer.loadPages()
                if let lastIndex = pages.indices.last, lastIndex < self.page {
                    self.page = 0
                }

                let dataWithImages = try await self.networkLayer.load(for: pages[self.page].users)

                Task { @MainActor in
                    self.userViewModels.append(contentsOf: dataWithImages)
                }
            } catch {
                print("Handle errors")
            }
        }
    }
}
