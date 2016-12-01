//
//  WWWFetchingTests.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import XCTest
import Foundation
import Dispatch
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
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "catching networking error")
        sut.baseURL = URL(string: "http://example.com")! // Set the wrong base URL
        sut.fetchDivisions { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNil(self.sut.divisions)
            XCTAssertNotNil(returnedError)
        }
    }

    func testFetchDivisionsFromWWW() {
        
        // Given
        XCTAssertNil(sut.divisions)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching divisions")
        sut.fetchDivisions { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
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
        division.timetable = sut
        XCTAssertNil(division.studyLevels)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching study levels")
        division.fetchStudyLevels { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
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
        admissionYear.timetable = sut
        XCTAssertNil(admissionYear.studentGroups)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching student groups")
        admissionYear.fetchStudentGroups { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
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
        studentGroup.timetable = sut
        XCTAssertNil(studentGroup.currentWeek)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching current week")
        studentGroup.fetchCurrentWeek { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(studentGroup.currentWeek)
            XCTAssertNotNil(studentGroup.currentWeek?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchArbitraryWeekFromWWW() {
        
        // Given
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        studentGroup.timetable = sut
        var returnedWeek: Week?
        let day = Date().addingTimeInterval(60*60*24*7)
        
        // When
        let exp = expectation(description: "fetching arbitrary week")
        studentGroup.fetchWeek(beginningWithDay: day) { result in
            if case .success(let value) = result {
                returnedWeek = value
            }
            
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(returnedWeek)
        }
    }
    
    func testFetchNextPreviousWeekFromWWW() {
        
        // Given
        let studentGroup = StudentGroup(id: 10014,
                                        name: "351 (14.Б10-мм)",
                                        studyForm: "очная",
                                        profiles: "",
                                        divisionAlias: "MATH")
        studentGroup.timetable = sut
        var current: Week?
        var next: Week?
        var previous: Week?
        
        // When
        let exp = expectation(description: "fetching next week")

        
        studentGroup.fetchCurrentWeek(dispatchQueue: .global(qos: .utility)) { result in
            
            if case .success(let _current) = result {
                
                current = _current
                
                _current.fetchNextWeek(dispatchQueue: .global(qos: .utility)) { result in
                    
                    if case .success(let _next) = result {
                        next = _next
                    }
                    
                    _current.fetchPreviousWeek(dispatchQueue: .global(qos: .utility)) { result in
                        
                        if case .success(let _previous) = result {
                            previous = _previous
                        }
                        
                        exp.fulfill()
                    }
                }
            }
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(current)
            XCTAssertNotNil(next)
            XCTAssertNotNil(previous)
            XCTAssertEqual(current?.next, next)
            XCTAssertEqual(next?.previous, current)
            XCTAssertEqual(previous?.next, current)
            XCTAssertEqual(previous, current?.previous)
        }
    }
    
    func testFetchBillboardFromWWW() {
        
        // Given
        XCTAssertNil(sut.billboard)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching billboard")
        sut.fetchBillboard { result in
            
            if case .failure(let error) = result {
                returnedError = error
            }
            
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(self.sut.billboard)
            XCTAssertNotNil(self.sut.billboard?.timetable)
            XCTAssertNil(returnedError)
        }
    }
}
