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

        // When
        var divisions: [Division]?
        sut.fetchDivisions(forceReload: false) { result in

            if case .success(let _divisions) = result {
                divisions = _divisions
            }
        }

        // Then
        XCTAssertNotNil(divisions)
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

        // When
        var studyLevels: [StudyLevel]?
        division.fetchStudyLevels(forceReload: false) { result in

            if case .success(let _studyLevels) = result {
                studyLevels = _studyLevels
            }
        }

        // Then
        XCTAssertNotNil(studyLevels)
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

        // When
        var studentGroups: [StudentGroup]?
        admissionYear.fetchStudentGroups(forceReload: false) { result in

            if case .success(let _studentGroups) = result {
                studentGroups = _studentGroups
            }
        }

        // Then
        XCTAssertNotNil(studentGroups)
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

        // When
        var week: Week?
        studentGroup.fetchCurrentWeek(forceReload: false) { result in

            if case .success(let _week) = result {
                week = _week
            }
        }

        // Then
        XCTAssertNotNil(week)
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

        // When
        var billboard: Extracurricular?
        sut.fetchBillboard(forceReload: false) { result in

            if case .success(let _billboard) = result {
                billboard = _billboard
            }
        }

        // Then
        XCTAssertNotNil(billboard)
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
    
    func testFetchScienceLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Science_events", ofType: "json")!
        var completionCalled = false
        
        XCTAssertNil(sut.billboard)
        
        // When
        sut.fetchScience(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNotNil(sut.science)

        // When
        var science: Science?
        sut.fetchScience(forceReload: false) { result in

            if case .success(let _science) = result {
                science = _science
            }
        }

        // Then
        XCTAssertNotNil(science)
    }
    
    func testFetchScienceLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchScience(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(sut.science)
    }
    
    func testFetchPELocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "PhysTraining_events", ofType: "json")!
        var completionCalled = false
        
        XCTAssertNil(sut.physicalEducation)
        
        // When
        sut.fetchPhysicalEducation(using: jsonData) { _ in
            completionCalled = true
        }
        
        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNotNil(sut.physicalEducation)

        // When
        var physicalEducation: Extracurricular?
        sut.fetchPhysicalEducation(forceReload: false) { result in

            if case .success(let _physicalEducation) = result {
                physicalEducation = _physicalEducation
            }
        }

        // Then
        XCTAssertNotNil(physicalEducation)
    }
    
    func testFetchPELocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchPhysicalEducation(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(sut.physicalEducation)
    }
    
    func testFetchEducatorsLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Educators", ofType: "json")!
        var returnedEducators: [Educator]?
        
        // When
        sut.fetchEducators(byLastName: "", using: jsonData) { result in
            if case .success(let educators) = result {
                returnedEducators = educators
            }
        }
        
        // Then
        XCTAssertEqual(returnedEducators?.count, 2)
    }
    
    func testFetchEducatorsLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchEducators(byLastName: "", using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }
    
    func testFetchEducatorScheduleByIDLocallyFromCorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Educators_2888_events", ofType: "json")!
        var returnedSchedule: EducatorSchedule?
        
        // When
        sut.fetchEducatorSchedule(byEducatorID: 0, using: jsonData) { result in
            
            if case .success(let schedule) = result {
                returnedSchedule = schedule
            }
        }
        
        // Then
        XCTAssertNotNil(returnedSchedule)
    }
    
    func testFetchEducatorScheduleByIDLocallyFromIncorrectJSONData() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?
        
        // When
        sut.fetchEducatorSchedule(byEducatorID: 0, using: jsonData) { result in
            
            if case .failure(let error) = result {
                receivedError = error
            }
        }
        
        // Then
        XCTAssertNotNil(receivedError)
    }

    func testFetchAddressesLocallyFromCorrectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "addresses", ofType: "json")!
        var completionCalled = false

        XCTAssertNil(sut.addresses)

        // When
        sut.fetchAllAddresses(using: jsonData) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(sut.addresses?.count, 126)

        // When
        var addresses: [Address]?
        sut.fetchAllAddresses(forceReload: false) { result in

            if case .success(let _addresses) = result {
                addresses = _addresses
            }
        }

        // Then
        XCTAssertNotNil(addresses)
    }

    func testFetchAddressesLocallyFromIncorrectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        var receivedError: Error?

        // When
        sut.fetchAddresses(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(sut.addresses)
    }

    func testFetchRoomsLocallyFromCorrectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "address_baf0eed7-4ef8-4e37-8dfb-df91d9021bd4_locations", ofType: "json")!
        let address = Address(name: "Университетский просп., д. 28",
                              matches: 112,
                              wantingEquipment: nil,
                              oid: "baf0eed7-4ef8-4e37-8dfb-df91d9021bd4")
        var completionCalled = false

        XCTAssertNil(address.rooms)

        // When
        address.fetchAllRooms(using: jsonData) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(address.rooms?.count, 112)

        // When
        var rooms: [Room]?
        address.fetchAllRooms(forceReload: false) { result in

            if case .success(let _rooms) = result {
                rooms = _rooms
            }
        }

        // Then
        XCTAssertNotNil(rooms)
    }

    func testFetchRoomsLocallyFromIncorrectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        let address = Address(name: "Университетский просп., д. 28",
                              matches: 112,
                              wantingEquipment: nil,
                              oid: "baf0eed7-4ef8-4e37-8dfb-df91d9021bd4")
        var receivedError: Error?

        // When
        address.fetchAllRooms(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(address.rooms)
    }

    func testFetchRoomForLocationLocallyFromCorrectJSONData() {

        // Given
        let addressesData = getTestingResource(fromFile: "addresses", ofType: "json")!
        let roomsData = getTestingResource(fromFile: "address_baf0eed7-4ef8-4e37-8dfb-df91d9021bd4_locations",
                                               ofType: "json")!

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

        var completionCalled = false

        XCTAssertNil(location.room)

        // When
        location.fetchRoom(addressesData: addressesData, roomsData: roomsData) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertEqual(location.room?.name, "1510")
        XCTAssertEqual(location.room?.address?.name, "Университетский просп., д. 28")

        // When
        var room: Room?
        location.fetchRoom { result in

            if case .success(let _room) = result {
                room = _room
            }
        }

        // Then
        XCTAssertNotNil(room)
    }

    func testFetchRoomForLocationLocallyFromIncorrectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
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
        var receivedError: Error?

        // When
        location.fetchRoom(addressesData: jsonData, roomsData: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(location.room)
    }

    func testFetchExtracurricularEventsForDivisionFromCoorectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "LIAS_events", ofType: "json")!
        let division = Division(name: "Свободные искусства и науки",
                                alias: "LIAS",
                                oid: "8bb888f3-2dfa-4bd3-978c-603a14883883")
        var completionCalled = false

        XCTAssertNil(division.extracurricularEvents)

        // When
        division.fetchExtracurricularEvents(using: jsonData) { _ in
            completionCalled = true
        }

        // Then
        XCTAssertTrue(completionCalled)
        XCTAssertNotNil(division.extracurricularEvents)

        // When
        var events: Extracurricular?
        division.fetchExtracurricularEvents(forceReload: false) { result in

            if case .success(let _events) = result {
                events = _events
            }
        }

        // Then
        XCTAssertNotNil(events)
    }

    func testFetchExtracurricularEventsForDivisionFromIncoorectJSONData() {

        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let division = Division(name: "Свободные искусства и науки",
                                alias: "LIAS",
                                oid: "8bb888f3-2dfa-4bd3-978c-603a14883883")

        var receivedError: Error?

        // When
        division.fetchExtracurricularEvents(using: jsonData) { result in
            if case .failure(let error) = result {
                receivedError = error
            }
        }

        // Then
        XCTAssertNotNil(receivedError)
        XCTAssertNil(division.extracurricularEvents)
    }
}
