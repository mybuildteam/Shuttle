import Foundation
import Moya

extension Client {
    func handleTwoStep(response: [String: Any]) {
        let appleIdSessionId = response["x-apple-id-session-id"] as! String
        let scnt = response["scnt"] as! String

        appleAuthProvider.request(.twoStepAuth(sessionId: appleIdSessionId, scnt: scnt)) { (response: Response) in
            print(response)
        }
    }

    func handleTwoFactor(securityCode: [String: Any]) throws {
        let twoFactorUrl = "https://github.com/kdawgwilk/Shuttle/tree/master    2-step-verification"
        print("Two Factor Authentication for account '\(user ?? "???")' is enabled")

        let cookiePersisted = false
        let shuttleSessionEnv = ""
        if !cookiePersisted && shuttleSessionEnv.isEmpty {
            print("If you're running this in a non-interactive session (e.g. server or CI)")
            print("check out \(twoFactorUrl)")
        } else {
            // If the cookie is set but still required, the cookie is expired
            print("Your session cookie has been expired.")
        }

        // [
        //     "length": 6,
        //     "tooManyCodesSent": false,
        //     "tooManyCodesValidated": false,
        //     "securityCodeLocked": false
        // ]
        let codeLength = securityCode["length"] as! Int
        // TODO: Prompt here
        print("Please enter the \(codeLength) digit code: ")
        let code = ""
        print("Requesting session...")

        // Send securityCode back to server to get a valid session
        appleAuthProvider.request(.securityCode(code)) { (response: Response) in
            print(response)
        }

        // we use `TunesClient.handleITCResponse`
        // since this might be from the Dev Portal, but for 2 step
//        TunesClient.handleITCResponse(r.body)

        storeSession()

    }

    // Only needed for 2 step
    func loadSessionFromFile() -> String? {
        return ""
    }

    func loadSessionFromEnv() -> String? {
        return ""
    }

    // Fetch the session cookie from the environment
    // (if exists)
    static var shuttleSessionEnv: String? {
        return ""
    }

    func selectDevice(id: String) throws {
        
    }

    func storeSession() {
        // If the request was successful, r.body is actually nil
        // The previous request will fail if the user isn't on a team
        // on iTunes Connect, but it still works, so we're good

        // Tell iTC that we are trustworthy (obviously)
        // This will update our local cookies to something new
        // They probably have a longer time to live than the other poor cookies
        // Changed Keys
        // - myacinfo
        // - DES5c148586dfd451e55afb0175f62418f91
        // We actually only care about the DES value

        appleAuthProvider.request(.trust) { (response: Response) in

        }

        // This request will fail if the user isn't added to a team on iTC
        // However we don't really care, this request will still return the
        // correct DES... cookie

//        storeCookie()
    }
}
