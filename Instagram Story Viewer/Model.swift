struct Root: Decodable {
    let pages: [Page]
}

struct Page: Decodable {
    let users: [User]
}

struct User: Decodable {
    let id: Int
    let name: String
    let profile_picture_url: String
}
