import Foundation
import Moya
import MoyaSugar

enum AppleAuthAPI {
    case signIn(email: String, password: String, cookie: String?)
    case twoStepAuth(sessionId: String, scnt: String)
    case securityCode(String)
    case selectDevice(deviceId: String)
    case trust
}

extension AppleAuthAPI: SugarTargetType {
    var baseURL: URL {
        return URL(string: "https://idmsa.apple.com/appleauth/auth")!
    }

    var route: Route {
        switch self {
        case .signIn:
            return .post("/signin")
        case .twoStepAuth:
            return .get("")
        case .securityCode:
            return .post("/verify/trusteddevice/securitycode")
        case .selectDevice(let deviceId):
            return .put("/verify/device/\(deviceId)/securitycode")
        case .trust:
            return .get("/2sv/trust")
        }
    }

    var params: Parameters? {
        switch self {
        case .signIn(let email, let password, _):
            return JSONEncoding() => [
                "accountName": email,
                "password": password,
                "rememberMe": true,
            ]
        case .securityCode(let code):
            return JSONEncoding() => [
                "securityCode": [
                    "code": code
                ]
            ]
        default:
            return nil
        }
    }

    var httpHeaderFields: [String: String]? {
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        // TODO: Set this
        headers["X-Apple-Widget-Key"] = "e0b80c3bf78523bfe80974d320935bfa30add02e1bff88ec2166c6bd5a706c42"
        headers["Accept"] = "application/json, text/javascript"

        switch self {
        case .signIn(_, _, let cookie):
            headers["X-Requested-With"] = "XMLHttpRequest"
            if let c = cookie {
                headers["Cookie"] = c
            }
            return headers
        case .twoStepAuth(let sessionId, let scnt):
            headers["X-Apple-Id-Session-Id"] = sessionId
            headers["scnt"] = scnt
        default:
            break
        }
        return headers
    }
}
