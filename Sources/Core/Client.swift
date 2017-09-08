import Foundation
import Alamofire
import Moya

//protocol BasicPreferredInfoError {
//    var preferredInfo: String { get }
//}

enum BasicPreferredInfoError: Swift.Error {
    case invalidUserCredentials
    case noUserCredentials
    case programLicenseAgreementUpdated
    case insufficientPermissions
    case unexpectedResponse
    case appleTimeoutError
    case unauthorizedAccessError
    case internalServerError

    // TODO: Implement
    var showGitHubIssues: Bool {
        return false
    }

    var preferredInfo: String? {
        switch self {
        case .insufficientPermissions:
            return "Insufficient permissions for your Apple ID: "
        case .unexpectedResponse:
            return "Apple provided the following error info: "
        default:
            return "The request could not be completed because: "
        }
    }
}

enum ITunesConnectError: Swift.Error {
    case generic(String)
    case temporaryError
    case potentialServerError
}

open class Client {
    let olympusProvider = MoyaProvider<OlympusAPI>()
    let appleAuthProvider = MoyaProvider<AppleAuthAPI>()

    let protocolVersion = "QH65B2"
    let userAgent = "Shuttle 1.0"

    var user: String? = nil
    var userEmail: String? = nil
    var csrfTokens = [String]()

    var userDetails: String {
        return ""
    }

    var teams: [Team] {
        return [Team]()
    }
    private var currentTeam: Team? = nil
    public var team: Team {
        if let ct = currentTeam { return ct }
        if teams.count > 1 {
            print("The current user is in \(teams.count) teams. Pass a team ID or call `selectTeam` to choose a team. Using the first one for now.")
        }
        let ct = teams[0]
        currentTeam = ct
        return ct
    }

    public func selectTeam(id: String) throws {
        let availableTeamIds = teams.map { String($0.providerId) }

        guard let team = teams.first(where: { String($0.providerId) == id }) else {
            throw ITunesConnectError.generic("Could not set team ID to '\(id)', only found the following available teams: \(availableTeamIds.joined(separator: ", "))")
        }

        // TODO: Send POST to select team
//        response = request(:post) do |req|
//            req.url "ra/v1/session/webSession"
//            req.body = {
//                contentProviderId: team_id,
//                dsId: user_detail_data.ds_id # https://github.com/fastlane/fastlane/issues/6711
//            }.to_json
//            req.headers['Content-Type'] = 'application/json'
//        end
        currentTeam = team
    }

    var hostname: String {
        fatalError("You must implement property hostname")
    }

    public static func clientWithAuth(from client: Client) -> Client {
        return Client()
    }

    init(cookie: String? = nil, teamId: String? = nil) {


    }

    var autobahnUserURL: URL {
        return URL(fileURLWithPath: "")
    }

    // Returns preferred path for storing cookie
    // for two step verification.
    var persistentCookieURL: URL {
//        if ENV["SPACESHIP_COOKIE_PATH"]
//          path = File.expand_path(File.join(ENV["SPACESHIP_COOKIE_PATH"], "spaceship", self.user, "cookie"))
//        else
//          [File.join(self.fastlane_user_dir, "spaceship"), "~/.spaceship", "/var/tmp/spaceship", "#{Dir.tmpdir}/spaceship"].each do |dir|
//          dir_parts = File.split(dir)
//          if directory_accessible?(File.expand_path(dir_parts.first))
//            path = File.expand_path(File.join(dir, self.user, "cookie"))
//            break
//          end
//        end
        return URL(fileURLWithPath: "")
    }

    // MARK: - Paging

    // The page size we want to request, defaults to 500
    var pageSize = 500

    // Handles the paging for you... for free
    // Just pass a block and use the parameter as page number
    func paging<T>(_ block: (Int) -> [Result<T>]?) -> [Result<T>] {
        var page = 0
        var results = [Result<T>]()
        while true {
            page += 1
            let current = block(page)
            if let result = current {
                results.append(contentsOf: result)
            }
            if (current ?? []).count < pageSize { break }
        }
        return results
    }

    // MARK: - Login and Team Selection

    public func login(user: String, password: String) -> Client {
        return Client()
    }

    func sendSharedLoginRequest(user: String, password: String) {
        let parameters: Parameters = [
            "accountName": user,
            "password": password,
            "rememberMe": true,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Requested-With": "XMLHttpRequest",
            "X-Apple-Widget-Key": itcServiceKey,
            "Accept": "application/json, text/javascript",
//            "Cookie": modified_cookie,
        ]
        request("https://idmsa.apple.com/appleauth/auth/signin",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .responseJSON { response in
                switch response.response?.statusCode {
                default:
                    return
                }
        }
    }

    lazy var itcServiceKey: String = {
        // TODO: Cache this somewhere

        request("https://olympus.itunes.apple.com/v1/app/config?hostname=itunesconnect.apple.com", method: .get)
            .responseDecodableObject { (response: DataResponse<AuthService>) in
                let authService = response.result.value
        }
        return ""
    }()
}

