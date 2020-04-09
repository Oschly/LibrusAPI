import XCTest
@testable import LibrusAPI

final class LibrusAPITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LibrusAPI().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
