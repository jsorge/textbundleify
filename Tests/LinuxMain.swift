import XCTest

import textbundleifyTests

var tests = [XCTestCaseEntry]()
tests += textbundleifyTests.allTests()
XCTMain(tests)