// Copyright © 2019 ChouTi. All rights reserved.

import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    static var allTests = [
        ("testNormal", testNormal),
        ("testQuotes", testQuotes),
        ("testEmptyFileds", testEmptyFileds),
        ("testToJSON", testToJSON),
        ("testJSONToCSV", testJSONToCSV),
    ]

    func testNormal() {
        let testone = try! CSVParser(
            content: "id,\"name\",age,job\n1,name1,20,job1\n2,name2,20,job2"
        )
//        for i in testone{
//            print(i)
//        }
        XCTAssertTrue(testone[0] == ["id", "name", "age", "job"])
        XCTAssertTrue(testone[1] == ["1", "name1", "20", "job1"])
        XCTAssertTrue(testone[2] == ["2", "name2", "20", "job2"])
    }

    func testQuotes() {
        let testone = try! CSVParser(
            content: "id,\"name, first\",\"name,last\"\n4,\"Alex\",Smith\n5,Joe,Bloggs\n9,\"Person, with a \"\"quote\"\" in their name\",uugh\n10,\"Person, with escaped comma\",Jones\n10,Person with a backslash,Jones\n12,\"Newlines\nare the best\",Woo hoo"
        )
//        for i in testone{
//            print(i)
//        }
        XCTAssertTrue(testone[0] == ["id", "name, first", "name,last"])
        XCTAssertTrue(testone[1] == ["4", "Alex", "Smith"])
        XCTAssertTrue(testone[2] == ["5", "Joe", "Bloggs"])
        XCTAssertTrue(testone[3] == ["9", "Person, with a \"\"quote\"\" in their name", "uugh"])
        XCTAssertTrue(testone[4] == ["10", "Person, with escaped comma", "Jones"])
        XCTAssertTrue(testone[5] == ["10", "Person with a backslash", "Jones"])
        XCTAssertTrue(testone[6] == ["12", "Newlines\nare the best", "Woo hoo"])
    }

    func testEmptyFileds() {
        let testone = try! CSVParser(
            content: "\"id\",name,age\n1,John,23\n2,James,32\n3,,\n6\n\n,Tom"
        )
//        for i in testone{
//            print(i)
//        }
        XCTAssertTrue(testone[0] == ["id", "name", "age"])
        XCTAssertTrue(testone[1] == ["1", "John", "23"])
        XCTAssertTrue(testone[2] == ["2", "James", "32"])
        XCTAssertTrue(testone[3] == ["3", "", ""])
        XCTAssertTrue(testone[4] == ["6"])
        XCTAssertTrue(testone[5] == [""])
        XCTAssertTrue(testone[6] == ["", "Tom"])
    }

    func testToJSON() {
        let testone = try! CSVParser(
            content: "id,\"name\",age,job\n1,name1,20,job1\n2,name2,20,job2"
        )
//        print(try!testone.toJSON()!)
        XCTAssertTrue((try! testone.toJSON()!) == "[\n  {\n    \"name\" : \"name1\",\n    \"age\" : \"20\",\n    \"id\" : \"1\",\n    \"job\" : \"job1\"\n  },\n  {\n    \"name\" : \"name2\",\n    \"age\" : \"20\",\n    \"id\" : \"2\",\n    \"job\" : \"job2\"\n  }\n]")
    }

    func testJSONToCSV() {
        let testone = try! CSVParser.jsonToCSVString(
            jsonData: "[\n  {\n    \"name\" : \"name1\",\n    \"age\" : \"20\",\n    \"id\" : \"1\",\n    \"job\" : \"job1\"\n  },\n  {\n    \"name\" : \"name2\",\n    \"age\" : \"20\",\n    \"id\" : \"2\",\n    \"job\" : \"job2\"\n  }\n]".data(using: .utf8)!
        )
//        print(testone as String?)
        XCTAssertTrue(testone == "age,name,id,job\n20,name1,1,job1\n20,name2,2,job2")
    }
}
