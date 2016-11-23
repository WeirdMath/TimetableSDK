//
//  LocalFetchingTests.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import XCTest
import Foundation
@testable import TimetableSDK

class LocalFetchingTests: XCTestCase {
    
    var sut: Timetable!

    override func setUp() {
        super.setUp()
        
        sut = Timetable()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchDivisionsLocally() {
        
        // Given
        let correctJSONData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let incorrectJSONData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var completionCalled = false
        var receivedError: Error?
        
        XCTAssertNil(sut.divisions)
        
        // When
        sut.fetchDivisions(using: correctJSONData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertNotNil(sut.divisions)
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(sut.divisions?.count, 26)
        
        // When
        sut.fetchDivisions(using: incorrectJSONData) { error in
            receivedError = error
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }
}
