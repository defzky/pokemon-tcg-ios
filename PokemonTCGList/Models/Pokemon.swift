struct Pokemon: Identifiable, Codable {
    let id: Int
    let name: String
    let image: String
    let description: String
    let origin: String
    let type: String
}
