@testable import Shuttle
import XCTest

class ShuttleTests: XCTestCase {
    var shuttle: Shuttle!

    override func setUp() {
        super.setUp()
        shuttle = Shuttle()
    }

    func testSelectTeam() {
//        XCTAssert(Shuttle.selectTeam == "XXXXXXXXXX")
    }

    func testShouldInitializeWithAClient() {
//        XCTAssert(shuttle.client is PortalClient)
    }

    func testDevice() {

    }

    func testCertificate() {

    }

    func testProvisioningProfile() {

    }

    func testApp() {

    }

    func testAppGroup() {

    }
}

class LauncherTests: XCTestCase {
    func testHasAClient() {

    }

    func testReturnsAScopedModelClass() {

    }

    func testPassesTheClientToTheModels() {

    }
}
