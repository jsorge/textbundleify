import XCTest
@testable import textbundleify

final class textbundleifyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(textbundleify().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
