import XCTest
@testable import Jormungandr

final class JormungandrTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Jormungandr().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
