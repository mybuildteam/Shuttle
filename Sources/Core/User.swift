import Foundation

enum Role: String, Codable {
    case admin = "ADMIN"
}

struct User: Codable {
    let fullName: String
    let emailAddress: String
    let prsId: String
}
