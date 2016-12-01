//
//  WWWFetchingTests.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import XCTest
import Foundation
import DefaultStringConvertible
@testable import TimetableSDK

class WWWFetchingTests: XCTestCase {
    
    var sut: Timetable!

    override func setUp() {
        super.setUp()
        
        sut = Timetable()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCatchNetworkingError() {
        
        // Given
        XCTAssertNil(sut.divisions)
        let expectedError = TimetableError.networkingError(NSError())
        var returnedError: TimetableError?
        
        // When
        let exp = expectation(description: "catching networking error")
        sut.baseURL = URL(string: "http://example.com")! // Set the wrong base URL
        sut.fetchDivisions { error in
            
            returnedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNil(self.sut.divisions)
            XCTAssertEqual(expectedError, returnedError)
        }
    }

    func testFetchDivisionsFromWWW() {
        
        // Given
        XCTAssertNil(sut.divisions)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching divisions")
        sut.fetchDivisions { error in
            
            returnedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(self.sut.divisions)
            XCTAssertNotNil(self.sut.divisions?.first?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchStudyLevelsFromWWW() {
        
        // Given
        let division = Division(name:  "Математика, Механика",
                                alias: "MATH",
                                oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        XCTAssertNil(division.studyLevels)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching study levels")
        sut.fetchStudyLevels(for: division) { error in
            
            returnedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(division.studyLevels)
            XCTAssertNotNil(division.studyLevels?.first?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchStudentGroupsFromWWW() {
        
        // Given
        let admissionYear = AdmissionYear(isEmpty: false,
                                          divisionAlias: "MATH",
                                          studyProgramID: 8162,
                                          name: "2016",
                                          number: 2016)
        XCTAssertNil(admissionYear.studentGroups)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching student groups")
        sut.fetchStudentGroups(for: admissionYear) { error in
            
            returnedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(admissionYear.studentGroups)
            XCTAssertNotNil(admissionYear.studentGroups?.first?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchCurrentWeekFromWWW() {
        
        // Given
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        XCTAssertNil(studentGroup.currentWeek)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching current week")
        sut.fetchCurrentWeek(for: studentGroup) { error in
            
            returnedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(studentGroup.currentWeek)
            XCTAssertNotNil(studentGroup.currentWeek?.timetable)
            XCTAssertNil(returnedError)
        }
    }
}
