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
            XCTAssertNotNil(division.studyLevels?.first?.specializations.first?.timetable)
            XCTAssertNotNil(division.studyLevels?.first?.specializations.first?.admissionYears.first?.timetable)
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
            XCTAssertNotNil(studentGroup.currentWeek?.days.first?.timetable)
            XCTAssertNotNil(studentGroup.currentWeek?.days.first?.events.first?.timetable)
            XCTAssertNotNil(studentGroup.currentWeek?.days.first?.events.first?.locations?.first?.timetable)
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
            XCTAssertNotNil(returnedWeek?.timetable)
            XCTAssertNotNil(returnedWeek?.days.first?.timetable)
            XCTAssertNotNil(returnedWeek?.days.first?.events.first?.timetable)
            XCTAssertNotNil(returnedWeek?.days.first?.events.first?.locations?.first?.timetable)
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
            XCTAssertNotNil(next?.timetable)
            XCTAssertNotNil(next?.days.first?.timetable)
            XCTAssertNotNil(next?.days.first?.events.first?.timetable)
            XCTAssertNotNil(next?.days.first?.events.first?.locations?.first?.timetable)
            XCTAssertNotNil(previous?.timetable)
            XCTAssertNotNil(previous?.days.first?.timetable)
            XCTAssertNotNil(previous?.days.first?.events.first?.timetable)
            XCTAssertNotNil(previous?.days.first?.events.first?.locations?.first?.timetable)
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
            XCTAssertNotNil(self.sut.billboard?.days.first?.timetable)
            XCTAssertNotNil(self.sut.billboard?.days.first?.events.first?.timetable)
            XCTAssertNotNil(self.sut.billboard?.days.first?.events.first?.location?.timetable)
            XCTAssertNotNil(self.sut.billboard?.earlierEvents.first?.timetable)
            XCTAssertNotNil(self.sut.billboard?.earlierEvents.first?.location?.timetable)
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
            XCTAssertNotNil(returnedBillblard?.timetable)
            XCTAssertNotNil(returnedBillblard?.days.first?.timetable)
            XCTAssertNotNil(returnedBillblard?.days.first?.events.first?.timetable)
            XCTAssertNotNil(returnedBillblard?.days.first?.events.first?.location?.timetable)
            XCTAssertNotNil(returnedBillblard?.earlierEvents.first?.timetable)
            XCTAssertNotNil(returnedBillblard?.earlierEvents.first?.location?.timetable)
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
            XCTAssertNotNil(self.sut.science?.eventGroupings.first?.timetable)
            XCTAssertNotNil(self.sut.science?.eventGroupings.first?.events.first?.timetable)
            XCTAssertNotNil(self.sut.science?.eventGroupings.first?.events.first?.location?.timetable)
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
            XCTAssertNotNil(returnedScience?.timetable)
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
            XCTAssertNotNil(self.sut.physicalEducation?.days.first?.timetable)
            XCTAssertNotNil(self.sut.physicalEducation?.days.first?.events.first?.timetable)
            XCTAssertNotNil(self.sut.physicalEducation?.days.first?.events.first?.location?.timetable)
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
            XCTAssertNotNil(returnedPE?.timetable)
            XCTAssertNotNil(returnedPE?.days.first?.timetable)
            XCTAssertNotNil(returnedPE?.days.first?.events.first?.timetable)
            XCTAssertNotNil(returnedPE?.days.first?.events.first?.location?.timetable)
        }
    }
    
    func testFetchEducatorsFromWWW() {
        
        // Given
        var returnedEducators: [Educator]?
        
        // When
        let exp = expectation(description: "fetching educators with provided last name")
        _ = sut.fetchEducators(byLastName: "Иванов").then { educators in
            returnedEducators = educators
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertFalse(returnedEducators?.isEmpty ?? true)
            XCTAssertNotNil(returnedEducators?.first?.timetable)
            XCTAssertNotNil(returnedEducators?.first?.employments.first?.timetable)
        }
    }
    
    func testFetchEducatorIDFromWWW() {
        
        // Given
        let educator = Educator(displayName: "", employments: [], fullName: "", id: 2888)
        educator.timetable = sut
        var returnedScheduleForCurrentTerm: EducatorSchedule?
        var returnedScheduleForNextTerm: EducatorSchedule?
        
        // When
        let exp = expectation(description: "fetching educator schedule")
        _ = educator.fetchSchedule(forNextTerm: false).then { schedule -> Promise<EducatorSchedule> in
            returnedScheduleForCurrentTerm = schedule
            return educator.fetchSchedule(forNextTerm: true)
        }.then { schedule in
            returnedScheduleForNextTerm = schedule
            exp.fulfill()
        }
        
        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(returnedScheduleForCurrentTerm)
            XCTAssertNotNil(returnedScheduleForCurrentTerm?.timetable)
            XCTAssertNotNil(returnedScheduleForCurrentTerm?.educatorEventsDays.first?.timetable)
            XCTAssertNotNil(returnedScheduleForCurrentTerm?.educatorEventsDays.first?.events.first?.timetable)
            XCTAssertNotNil(returnedScheduleForCurrentTerm?.educatorEventsDays.first?.events.first?.locations?.first?.timetable)
            XCTAssertNotNil(returnedScheduleForNextTerm)
            XCTAssertNotEqual(returnedScheduleForCurrentTerm?.educatorEventsDays ?? [],
                              returnedScheduleForNextTerm?.educatorEventsDays ?? [])
        }
    }

    func testFetchAllAdressesFromWWW() {

        // Given
        XCTAssertNil(sut.addresses)
        var returnedError: Error?

        // When
        let exp = expectation(description: "fetching all addresses")
        sut.fetchAllAddresses().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }

        // Then
        waitForExpectations(timeout: 10) { _ in

            XCTAssertNotNil(self.sut.addresses)
            XCTAssertNotNil(self.sut.addresses?.first?.timetable)
            XCTAssertNil(returnedError)
        }
    }

    func testFetchAddressesWithParametersFromWWW() {

        // Given
        var returnedAddresses: [Address]?

        // When
        let exp = expectation(description: "fetching addresses with provided parameters")
        _ = sut.fetchAddresses(seating: .amphitheater,
                               capacity: 10,
                               equipment: nil).then { addresses in

            returnedAddresses = addresses
            exp.fulfill()
        }

        // Then
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(returnedAddresses)
            XCTAssertNotNil(returnedAddresses?.first?.timetable)
        }
    }

    func testFetchAllRoomsFromWWW() {

        // Given
        let address = Address(name: "Университетский просп., д. 28",
                              matches: 112,
                              wantingEquipment: nil,
                              oid: "baf0eed7-4ef8-4e37-8dfb-df91d9021bd4")
        address.timetable = sut
        XCTAssertNil(address.rooms)
        var returnedError: Error?

        // When
        let exp = expectation(description: "fetching all rooms")
        address.fetchAllRooms().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }

        // Then
        waitForExpectations(timeout: 10) { _ in

            XCTAssertNotNil(address.rooms)
            XCTAssertNotNil(address.rooms?.first?.timetable)
            XCTAssert(address.rooms?.first?.address === address)
            XCTAssertNil(returnedError)
        }
    }

    func testFetchRoomsWithParametersFromWWW() {

        // Given
        let address = Address(name: " Университетская наб., д. 11",
                              matches: 196,
                              wantingEquipment: nil,
                              oid: "6572bd45-973c-4075-9d23-9dc728b37828")
        address.timetable = sut
        XCTAssertNil(address.rooms)
        var returnedError: Error?
        var returnedRooms: [Room]?

        // When
        let exp = expectation(description: "fetching all rooms")
        address.fetchRooms(seating: .theater,
                           capacity: 30,
                           equipment: nil).then { rooms in
            returnedRooms = rooms
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }

        // Then
        waitForExpectations(timeout: 10) { _ in

            XCTAssertNotNil(returnedRooms)
            XCTAssertNotNil(returnedRooms?.first?.timetable)
            XCTAssertNil(returnedError)
        }
    }

    func testFetchRoomForLocationFromWWW() {

        // Given
        let location = Location(educatorsDisplayText: "Евард М. Е., доцент",
                                hasEducators: true,
                                educatorIDs: [(2643, "Евард М. Е., доцент")],
                                isEmpty: false,
                                displayName: "Университетский просп., д. 28, 1510",
                                hasGeographicCoordinates: true,
                                latitude: 59.879785,
                                longitude: 29.829026,
                                latitudeValue: "59.879785",
                                longitudeValue: "29.829026")
        location.timetable = sut
        XCTAssertNil(location.room)

        var returnedError: Error?

        // When
        let exp = expectation(description: "fetching the room for location")
        location.fetchRoom().then { _ in
            exp.fulfill()
        }.catch { error in
            returnedError = error
        }


        // Then
        waitForExpectations(timeout: 10) { _ in

            XCTAssertNotNil(location.room)
            XCTAssertNotNil(location.room?.address)
            XCTAssertNotNil(location.room?.timetable)
            XCTAssertNotNil(location.room?.address?.timetable)
            XCTAssertNil(returnedError)
        }
    }
}
