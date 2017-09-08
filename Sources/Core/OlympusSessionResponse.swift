import Foundation

struct OlympusSessionResponse: Codable {
    let user: User
    let provider: Team
    let availableProviders: [Team]
    let backingType: String
    let roles: [Role]
    let unverifiedRoles: [Role]
//    let featureFlags: [String]
    let agreeToTerms: Bool
    let modules: [ITCModule]
    let helpLinks: [HelpLink]
}
