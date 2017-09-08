@testable import Core
import TestSupport
import XCTest

class DecodableTests: XCTestCase {
    func testDecodeOlympusSession200() {
        guard let data = Mock.olympusSession200.data(using: .utf8) else {
                XCTFail("Unable to get data from mock response")
                return
        }
        do {
            let sessionResponse = try JSONDecoder().decode(OlympusSessionResponse.self, from: data)
            XCTAssertNotNil(sessionResponse)
        } catch let error as DecodingError {
            switch error {
            case .dataCorrupted(let context):
                XCTFail("Decoding error: data corrupted in \(context)")
            case .typeMismatch(let type, let context):
                XCTFail("Decoding error: type mismatch for \(type) in \(context)")
            case .valueNotFound(let type, let context):
                XCTFail("Decoding error: value for type \(type) not found in \(context)")
            case .keyNotFound(let key, let context):
                XCTFail("Decoding error: key \(key) not found in \(context)")
            }
            XCTFail("Error Description: \(error.localizedDescription)")
        } catch let error {
            XCTFail("Unknown error: \(error.localizedDescription)")
        }
    }
}
