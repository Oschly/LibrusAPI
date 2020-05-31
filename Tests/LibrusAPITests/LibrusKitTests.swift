import XCTest
@testable import LibrusKit

final class LibrusKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LibrusKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
