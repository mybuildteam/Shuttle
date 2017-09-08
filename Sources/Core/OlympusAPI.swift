import Foundation
import Moya
import MoyaSugar

enum OlympusAPI {
    case itcServiceKey
    case session
}

extension OlympusAPI: SugarTargetType {
    var baseURL: URL {
        return URL(string: "https://olympus.itunes.apple.com/v1")!
    }

    var route: Route {
        switch self {
        case .itcServiceKey:
            return .get("/app/config?hostname=itunesconnect.apple.com")
        case .session:
            return .get("/session")
        }
    }
}
