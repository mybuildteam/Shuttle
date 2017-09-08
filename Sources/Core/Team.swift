enum ContentType: String, Codable {
    case software = "SOFTWARE"
}

protocol ContentProvider {
    var providerId: Int { get }
    var name: String { get }
    var contentTypes: [ContentType] { get }
}

public struct Team: ContentProvider, Codable {
    let providerId: Int
    let name: String
    let contentTypes: [ContentType]
}
