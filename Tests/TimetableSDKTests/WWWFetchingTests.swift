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
import PromiseKit
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
        
        sut.fetchDivisions().catch { error in
            returnedError = error
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
        sut.fetchDivisions().then { _ in
            exp.fulfill()
        }.catch { error in
                returnedError = error
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
        division.fetchStudyLevels().then { _ in
            exp.fulfill()
        }.catch { error in
                returnedError = error
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
        admissionYear.fetchStudentGroups().then { _ in
            exp.fulfill()
        }.catch { error in
                returnedError = error
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
        studentGroup.fetchCurrentWeek().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
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
        _ = studentGroup.fetchWeek(beginningWithDay: day).then { week in
            returnedWeek = week
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
        
        studentGroup.fetchCurrentWeek()
            .then { _current -> Promise<Week> in
            
            current = _current
            return current!.fetchNextWeek()
            
            }.then { _next -> Promise<Week> in
                
                next = _next
                return current!.fetchPreviousWeek()
                
            }.then { _previous in
                
                previous = _previous
                exp.fulfill()
                
            }.catch { error in
                
                XCTFail(String(describing: error))
                
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
    
    func testFetchBillboardForCurrentWeekFromWWW() {
        
        // Given
        XCTAssertNil(sut.billboard)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching billboard for current week")
        sut.fetchBillboard().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(self.sut.billboard)
            XCTAssertNotNil(self.sut.billboard?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchBillboardForArbitraryWeekFromWWW() {
        
        // Given
        var returnedBillblard: Extracurricular?
        let day = Date().addingTimeInterval(-60*60*24*7)
        
        // When
        let exp = expectation(description: "fetching billboard for arbitrary week")
        _ = sut.fetchBillboard(from: day).then { billboard in
            returnedBillblard = billboard
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(returnedBillblard)
        }
    }
    
    func testFetchScienceForCurrentWeekFromWWW() {
        
        // Given
        XCTAssertNil(sut.science)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching science for current week")
        sut.fetchScience().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(self.sut.science)
            XCTAssertNotNil(self.sut.science?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchScienceForArbitraryWeekFromWWW() {
        
        // Given
        var returnedScience: Science?
        let day = Date().addingTimeInterval(-60*60*24*7)
        
        // When
        let exp = expectation(description: "fetching science for arbitrary week")
        _ = sut.fetchScience(from: day).then { science in
            returnedScience = science
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(returnedScience)
        }
    }
    
    func testFetchPEForCurrentWeekFromWWW() {
        
        // Given
        XCTAssertNil(sut.physicalEducation)
        var returnedError: Error?
        
        // When
        let exp = expectation(description: "fetching physical education for current week")
        sut.fetchPhysicalEducation().then { _ in
            exp.fulfill()
        }.catch { error in
                returnedError = error
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            
            XCTAssertNotNil(self.sut.physicalEducation)
            XCTAssertNotNil(self.sut.physicalEducation?.timetable)
            XCTAssertNil(returnedError)
        }
    }
    
    func testFetchPEForArbitraryWeekFromWWW() {
        
        // Given
        var returnedPE: Extracurricular?
        let day = Date().addingTimeInterval(-60*60*24*7)
        
        // When
        let exp = expectation(description: "fetching physical education for arbitrary week")
        _ = sut.fetchPhysicalEducation(from: day).then { physicalEducation in
            returnedPE = physicalEducation
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(returnedPE)
        }
    }
}
