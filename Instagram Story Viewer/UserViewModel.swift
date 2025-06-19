import UIKit

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
