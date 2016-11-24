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
    
    func testFetchStudyLevelsLocally() {
        
        // Given
        let correctJSONData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        let incorrectJSONData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let division = Division(name:  "Математика, Механика",
                                alias: "MATH",
                                oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        var completionCalled = false
        var receivedError: Error?
        
        XCTAssertNil(division.studyLevels)
        
        // When
        sut.fetchStudyLevels(for: division, using: correctJSONData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertNotNil(division.studyLevels)
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(division.studyLevels?.count, 6)
        
        // When
        sut.fetchStudyLevels(for: division, using: incorrectJSONData) { error in
            receivedError = error
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }
    
    func testFetchStudentGroupsLocally() {
        
        // Given
        let correctJSONData = getTestingResource(fromFile: "MATH_studyprogram_5466_studentGroups", ofType: "json")!
        let incorrectJSONData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let admissionYear = AdmissionYear(isEmpty: false,
                                          divisionAlias: "MATH",
                                          studyProgramID: 8162,
                                          name: "2016",
                                          number: 2016)
        var completionCalled = false
        var receivedError: Error?
        
        XCTAssertNil(admissionYear.studentGroups)
        
        // When
        sut.fetchStudentGroups(for: admissionYear, using: correctJSONData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertNotNil(admissionYear.studentGroups)
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(admissionYear.studentGroups?.count, 1)
        
        // When
        sut.fetchStudentGroups(for: admissionYear, using: incorrectJSONData) { error in
            receivedError = error
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }
    
    func testFetchCurrentWeekLocally() {
        
        // Given
        let correctJSONData = getTestingResource(fromFile: "MATH_studentGroup_10014_events", ofType: "json")!
        let incorrectJSONData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        var completionCalled = false
        var receivedError: Error?
        
        XCTAssertNil(studentGroup.currentWeek)
        
        // When
        sut.fetchCurrentWeek(for: studentGroup, using: correctJSONData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertNotNil(studentGroup.currentWeek)
        XCTAssertTrue(completionCalled)
        
        // When
        sut.fetchCurrentWeek(for: studentGroup, using: incorrectJSONData) { error in
            receivedError = error
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }
}
