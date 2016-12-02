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
    
    func testFetchDivisionsLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        var completionCalled = false
        
        XCTAssertNil(sut.divisions)
        
        // When
        sut.fetchDivisions(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(sut.divisions?.count, 26)
    }
    
    func testFetchDivisionsLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchDivisions(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(sut.divisions)
    }
    
    func testFetchStudyLevelsLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        let division = Division(name:  "Математика, Механика",
                                alias: "MATH",
                                oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        var completionCalled = false
        
        XCTAssertNil(division.studyLevels)
        
        // When
        division.fetchStudyLevels(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(division.studyLevels?.count, 6)
    }
    
    func testFetchStudyLevelsLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let division = Division(name:  "Математика, Механика",
                                alias: "MATH",
                                oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        var receivedError: Error?
        
        // When
        division.fetchStudyLevels(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(division.studyLevels)
    }
    
    func testFetchStudentGroupsLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprogram_5466_studentGroups", ofType: "json")!
        let admissionYear = AdmissionYear(isEmpty: false,
                                          divisionAlias: "MATH",
                                          studyProgramID: 8162,
                                          name: "2016",
                                          number: 2016)
        var completionCalled = false
        
        XCTAssertNil(admissionYear.studentGroups)
        
        // When
        admissionYear.fetchStudentGroups(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(admissionYear.studentGroups?.count, 1)
    }
    
    func testFetchStudentGroupsLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let admissionYear = AdmissionYear(isEmpty: false,
                                          divisionAlias: "MATH",
                                          studyProgramID: 8162,
                                          name: "2016",
                                          number: 2016)
        var receivedError: Error?
        
        // When
        let exp = expectation(description: "testFetchStudentGroupsLocallyFromIncorrectJSONData")
        admissionYear.fetchStudentGroups(using: jsonData).catch { error in
            receivedError = error
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(receivedError)
            XCTAssertNil(admissionYear.studentGroups)
        }
    }
    
    func testFetchCurrentWeekLocallyFromCorrectJSONData() {
        
        // Given
        let correctJSONData = getTestingResource(fromFile: "MATH_studentGroup_10014_events", ofType: "json")!
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        var completionCalled = false
        
        XCTAssertNil(studentGroup.currentWeek)
        
        // When
        studentGroup.fetchCurrentWeek(using: correctJSONData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertNotNil(studentGroup.currentWeek)
        XCTAssertTrue(completionCalled)
    }
    
    func testFetchCurrentWeekLocallyFromIncorrectJSONData() {
        
        // Given
        let incorrectJSONData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        var receivedError: Error?
        
        // When
        studentGroup.fetchCurrentWeek(using: incorrectJSONData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(studentGroup.currentWeek)
    }
    
    func testFetchBillboardLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Billboard_events", ofType: "json")!
        var completionCalled = false
        
        XCTAssertNil(sut.billboard)
        
        // When
        sut.fetchBillboard(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNotNil(sut.billboard)
    }
    
    func testFetchBillboardLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchBillboard(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(sut.billboard)
    }
}
