// Copyright © 2019 ChouTi. All rights reserved.

import XCTest

#if !os(macOS)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(CSVParserTests.allTests),
        ]
    }
#endif
