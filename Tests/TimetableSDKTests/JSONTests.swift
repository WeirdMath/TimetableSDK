import XCTest
import SwiftyJSON
@testable import TimetableSDK

class JSONTests: XCTestCase {

    // MARK: - Initializing
    
    func testInitializeDivisionFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedDivision = Division(name:  "Математика, Механика",
                                        alias: "MATH",
                                        oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        
        // When
        let returnedDivision = try? Division(from: json[7])
        
        // Then
        XCTAssertEqual(expectedDivision, returnedDivision)
    }
    
    func testInitializeStudyLevelFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprograms", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedStudyLevel =
            StudyLevel(name: "Аспирантура",
                       specializations: [
                        Specialization(name: "Астрономия",
                                       admissionYears: [
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 8162,
                                                      name: "2016",
                                                      number: 2016),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 2103,
                                                      name: "2015",
                                                      number: 2015),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 7306,
                                                      name: "2014",
                                                      number: 2014)
                            ]),
                        Specialization(name: "Вычислительная математика и кибернетика",
                                       admissionYears: [
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 3993,
                                                      name: "2015",
                                                      number: 2015),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 6652,
                                                      name: "2014",
                                                      number: 2014)
                            ]),
                        Specialization(name: "Информатика",
                                       admissionYears: [
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 8115,
                                                      name: "2016",
                                                      number: 2016),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 4543,
                                                      name: "2015",
                                                      number: 2015),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 7622,
                                                      name: "2014",
                                                      number: 2014)
                            ]),
                        Specialization(name: "Математика",
                                       admissionYears: [
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 8188,
                                                      name: "2016",
                                                      number: 2016),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 7274,
                                                      name: "2015",
                                                      number: 2015),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 1340,
                                                      name: "2014",
                                                      number: 2014)
                            ]),
                        Specialization(name: "Механика",
                                       admissionYears: [
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 8064,
                                                      name: "2016", number: 2016),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 7550,
                                                      name: "2015",
                                                      number: 2015),
                                        AdmissionYear(isEmpty: false,
                                                      divisionAlias: "MATH",
                                                      studyProgramID: 2020,
                                                      name: "2014",
                                                      number: 2014)
                            ])
                ],
                       hasCourse6: false)
        
        // When
        let returnedStudyLevel = try? StudyLevel(from: json[0])
        
        // Then
        XCTAssertEqual(expectedStudyLevel, returnedStudyLevel)
    }
    
    func testInitializeStudentGroupFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprogram_5466_studentGroups", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedStudentGroup = StudentGroup(id: 10014,
                                                name: "351 (14.Б10-мм)",
                                                studyForm: "очная",
                                                profiles: "",
                                                divisionAlias: "MATH")
        
        // When
        let returnedStudentGroup = try? StudentGroup(from: json[0])
        
        // Then
        XCTAssertEqual(expectedStudentGroup, returnedStudentGroup)
    }
    
    func testInitializeWeekFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studentGroup_10014_events", ofType: "json")!
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let expectedWeek = Week(previousWeekFirstDay: dateFomatter.date(from: "2016-11-14")!,
                                nextWeekFirstDay: dateFomatter.date(from: "2016-11-28")!,
                                isPreviousWeekReferenceAvailable: true,
                                isNextWeekReferenceAvailable: true,
                                isCurrentWeekReferenceAvailable: false,
                                weekDisplayText: "21 ноября – 27 ноября",
                                days: [
                                    Day(number: nil,
                                        date: timeFormatter.date(from: "2016-11-21T00:00:00")!,
                                        name: "понедельник, 21 ноября",
                                        events: [
                                            Event(allDay: false,
                                                  contingentUnitsDisplayText: nil,
                                                  contingentUnitNames: nil,
                                                  dateWithTimeIntervalString: "21 ноября 9:30-11:05",
                                                  dates: nil,
                                                  displayDateAndTimeIntervalString: "21 ноября 9:30-11:05",
                                                  divisionAlias: nil,
                                                  educatorsDisplayText: "Евард М. Е., доцент",
                                                  end: timeFormatter.date(from: "2016-11-21T11:05:00")!,
                                                  fromDate: nil,
                                                  fromDateString: nil,
                                                  fullDateWithTimeIntervalString: nil,
                                                  hasAgenda: nil,
                                                  hasEducators: true,
                                                  hasTheSameTimeAsPreviousItem: false,
                                                  id: nil,
                                                  isCancelled: false,
                                                  isEmpty: nil,
                                                  isRecurrence: nil,
                                                  isShowImmediateHidden: nil,
                                                  isStudy: false,
                                                  location: nil,
                                                  locationsDisplayText: "Университетский просп., д. 28, 1510",
                                                  orderIndex: nil,
                                                  showImmediate: nil,
                                                  showYear: nil,
                                                  start: timeFormatter.date(from: "2016-11-21T09:30:00")!,
                                                  subject: "Механика деформируемого твердого тела, " +
                                                "практическое занятие, факультатив",
                                                  subkindDisplayName: nil,
                                                  timeIntervalString: "9:30–11:05",
                                                  viewKind: nil,
                                                  withinTheSameDay: false,
                                                  year: nil,
                                                  locations: [
                                                    Location(educatorsDisplayText: "Евард М. Е., доцент",
                                                             hasEducators: true,
                                                             educatorIDs: [(2643, "Евард М. Е., доцент")],
                                                             isEmpty: false,
                                                             displayName:
                                                        "Университетский просп., д. 28, 1510",
                                                             hasGeographicCoordinates: true,
                                                             latitude: 59.879785,
                                                             longitude: 29.829026,
                                                             latitudeValue: "59.879785",
                                                             longitudeValue: "29.829026")
                                                ],
                                                  kind: nil,
                                                  contingentUnitName: "",
                                                  educatorIDs: [(2643, "Евард М. Е., доцент")],
                                                  contingentUnitCourse: "",
                                                  contingentUnitDivision: "",
                                                  isAssigned: false,
                                                  timeWasChanged: false,
                                                  locationsWereChanged: false,
                                                  educatorsWereReassigned: false)
                                        ])
            ],
                                viewName: "Primary",
                                firstDay: dateFomatter.date(from: "2016-11-21")!,
                                studentGroupID: 10014,
                                studentGroupDisplayName: "Группа 351 (14.Б10-мм)",
                                timetableDisplayName: "Все занятия")
        
        // When
        let returnedWeek = try? Week(from: jsonData)
        
        // Then
        XCTAssertEqual(expectedWeek, returnedWeek)
        
    }
    
    func testInitializeExtracurricularFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Billboard_events", ofType: "json")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let expectedExtracurricular =
            Extracurricular(alias: "Billboard",
                            days: [
                                Day(number: nil,
                                    date: timeFormatter.date(from: "2016-11-28T00:00:00")!,
                                    name: "понедельник, 28 ноября",
                                    events: [])
                ],
                            earlierEvents: [
                                Event(allDay: true,
                                      contingentUnitsDisplayText: "",
                                      contingentUnitNames: nil,
                                      dateWithTimeIntervalString: "15.09 - 30.03",
                                      dates: nil,
                                      displayDateAndTimeIntervalString: "15.09 - 30.03",
                                      divisionAlias: "Billboard",
                                      educatorsDisplayText: "",
                                      end: timeFormatter.date(from: "2017-03-31T00:00:00")!,
                                      fromDate: timeFormatter.date(from: "2016-09-12T00:00:00")!,
                                      fromDateString: "2016-09-12",
                                      fullDateWithTimeIntervalString: "15 сентября - 30 марта",
                                      hasAgenda: true,
                                      hasEducators: false,
                                      hasTheSameTimeAsPreviousItem: false,
                                      id: 485471,
                                      isCancelled: false,
                                      isEmpty: false,
                                      isRecurrence: false,
                                      isShowImmediateHidden: false,
                                      isStudy: false,
                                      location: Location(educatorsDisplayText: nil,
                                                         hasEducators: false,
                                                         educatorIDs: nil,
                                                         isEmpty: false,
                                                         displayName: "В.О., 10 линия, д. 33",
                                                         hasGeographicCoordinates: true,
                                                         latitude: 59.943003,
                                                         longitude: 30.27314,
                                                         latitudeValue: "59.943003",
                                                         longitudeValue: "30.27314"),
                                      locationsDisplayText: "",
                                      orderIndex: 100500100500,
                                      showImmediate: false,
                                      showYear: false,
                                      start: timeFormatter.date(from: "2016-09-15T00:00:00")!,
                                      subject: "Чемпионат по географическому брэйн-рингу",
                                      subkindDisplayName: "Иные мероприятия",
                                      timeIntervalString: "0:00–0:00",
                                      viewKind: 0,
                                      withinTheSameDay: false,
                                      year: 2016,
                                      locations: nil,
                                      kind: nil,
                                      contingentUnitName: nil,
                                      educatorIDs: nil,
                                      contingentUnitCourse: nil,
                                      contingentUnitDivision: nil,
                                      isAssigned: nil,
                                      timeWasChanged: nil,
                                      locationsWereChanged: nil,
                                      educatorsWereReassigned: nil)
                ],
                            hasEventsToShow: true,
                            isCurrentWeekReferenceAvailable: false,
                            isNextWeekReferenceAvailable: true,
                            isPreviousWeekReferenceAvailable: true,
                            nextWeekMonday: dateFormatter.date(from: "2016-12-05")!,
                            previousWeekMonday: dateFormatter.date(from: "2016-11-21")!,
                            title: "Афиша мероприятий",
                            viewName: "IndexWeek",
                            weekDisplayText: "28 ноября – 4 декабря",
                            weekMonday: dateFormatter.date(from: "2016-11-28")!)
        
        // When
        let returnedExtracurricular = try? Extracurricular(from: jsonData)
        
        // Then
        XCTAssertEqual(expectedExtracurricular, returnedExtracurricular)
    }
    
    func testInitializeScienceFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Science_events", ofType: "json")!
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let expectedScience =
            Science(alias: "Science",
                    chosenMonthDisplayText: "Ноябрь 2016",
                    eventGroupings: [
                        EventGrouping(caption: "Ученые, диссертационные советы",
                                      events: [
                                        Event(allDay: false,
                                              contingentUnitsDisplayText: "",
                                              contingentUnitNames: nil,
                                              dateWithTimeIntervalString: "16.11 9:00-11:00",
                                              dates: nil,
                                              displayDateAndTimeIntervalString: "16.11 9:00-11:00",
                                              divisionAlias: "Science",
                                              educatorsDisplayText: "",
                                              end: timeFormatter.date(from: "2016-11-16T11:00:00")!,
                                              fromDate: timeFormatter.date(from: "2016-11-01T00:00:00")!,
                                              fromDateString: "2016-11-01",
                                              fullDateWithTimeIntervalString: "16 ноября 9:00-11:00",
                                              hasAgenda: false,
                                              hasEducators: false,
                                              hasTheSameTimeAsPreviousItem: false,
                                              id: 502364,
                                              isCancelled: false,
                                              isEmpty: false,
                                              isRecurrence: false,
                                              isShowImmediateHidden: false,
                                              isStudy: false,
                                              location: Location(educatorsDisplayText: nil,
                                                                 hasEducators: false,
                                                                 educatorIDs: nil,
                                                                 isEmpty: false,
                                                                 displayName: "В.О., 6 линия, д. 15, 121",
                                                                 hasGeographicCoordinates: true,
                                                                 latitude: 59.940863,
                                                                 longitude: 30.271639,
                                                                 latitudeValue: "59.940863",
                                                                 longitudeValue: "30.271639"),
                                              locationsDisplayText: "В.О., 6 линия, д. 15, 121",
                                              orderIndex: 75375075375,
                                              showImmediate: false,
                                              showYear: false,
                                              start: timeFormatter.date(from: "2016-11-16T09:00:00")!,
                                              subject: "Иные мероприятия",
                                              subkindDisplayName: "Ученые, диссертационные советы",
                                              timeIntervalString: "9:00–11:00",
                                              viewKind: 1,
                                              withinTheSameDay: true,
                                              year: 2016,
                                              locations: nil,
                                              kind: nil,
                                              contingentUnitName: nil,
                                              educatorIDs: nil,
                                              contingentUnitCourse: nil,
                                              contingentUnitDivision: nil,
                                              isAssigned: nil,
                                              timeWasChanged: nil,
                                              locationsWereChanged: nil,
                                              educatorsWereReassigned: nil)
                            ])
                ],
                    hasEventsToShow: true,
                    isCurrentMonthReferenceAvailable: true,
                    nextMonth: dateFomatter.date(from: "2016-12-01")!,
                    nextMonthDisplayText: "Декабрь 2016 »",
                    previousMonth: dateFomatter.date(from: "2016-10-01")!,
                    previousMonthDisplayText: "« Октябрь 2016",
                    showGroupingCaptions: true,
                    title: "Научные мероприятия",
                    viewName: "IndexMonth")
        
        // When
        let returnedScience = try? Science(from: jsonData)
        
        // Then
        XCTAssertEqual(expectedScience, returnedScience)
    }
    
    func testInitializeEducatorFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Educators", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedEducator = Educator(displayName: "Романовский И. В.",
                                        employments: [
                                            Employment(department: "Кафедра исследования операций",
                                                       position: "профессор"),
                                            Employment(department: "ДГПХ",
                                                       position: "")
            ],
                                        fullName: "Романовский Иосиф Владимирович",
                                        id: 2888)
        
        // When
        let returnedEducator = try? Educator(from: json["Educators"][0])
        
        // Then
        XCTAssertEqual(expectedEducator, returnedEducator)
    }
    
    func testInitializeEducatorScheduleFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Educators_2888_events", ofType: "json")!
        let json = JSON(data: jsonData)
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let expectedSchedule = EducatorSchedule(autumnTermLinkAvailable: false,
                                                dateRangeDisplayText: "1 августа 2016 - 1 февраля 2017",
                                                educatorDisplayText: "Романовский И. В.",
                                                educatorEventsDays: [
                                                    Day(number: 1,
                                                        date: nil,
                                                        name: "Понедельник",
                                                        events: [
                                                            Event(allDay: nil,
                                                                  contingentUnitsDisplayText: nil,
                                                                  contingentUnitNames: [
                                                                    ("102 (16.Б02.0-мм)",
                                                                     "Математико-механический факультет, 1 курс")
                                                                ],
                                                                  dateWithTimeIntervalString: nil,
                                                                  dates: ["16.1"],
                                                                  displayDateAndTimeIntervalString: nil,
                                                                  divisionAlias: nil,
                                                                  educatorsDisplayText:
                                                                "Романовский И. В., профессор",
                                                                  end: timeFormatter.date(from: "14:00:00")!,
                                                                  fromDate: nil,
                                                                  fromDateString: nil,
                                                                  fullDateWithTimeIntervalString: nil,
                                                                  hasAgenda: nil,
                                                                  hasEducators: nil,
                                                                  hasTheSameTimeAsPreviousItem: nil,
                                                                  id: nil,
                                                                  isCancelled: false,
                                                                  isEmpty: nil,
                                                                  isRecurrence: nil,
                                                                  isShowImmediateHidden: nil,
                                                                  isStudy: nil,
                                                                  location: nil,
                                                                  locationsDisplayText: nil,
                                                                  orderIndex: nil,
                                                                  showImmediate: nil,
                                                                  showYear: nil,
                                                                  start: timeFormatter.date(from: "10:00:00")!,
                                                                  subject: "Теоретическая информатика, экзамен",
                                                                  subkindDisplayName: nil,
                                                                  timeIntervalString: "10:00-14:00",
                                                                  viewKind: nil,
                                                                  withinTheSameDay: nil,
                                                                  year: nil,
                                                                  locations: [
                                                                    Location(educatorsDisplayText:
                                                                        "Романовский И. В., профессор",
                                                                             hasEducators: true,
                                                                             educatorIDs: [
                                                                                (2888,
                                                                                 "Романовский И. В., профессор")
                                                                        ],
                                                                             isEmpty: false,
                                                                             displayName:
                                                                        "В.О., 14 линия, д. 29, 34",
                                                                             hasGeographicCoordinates: true,
                                                                             latitude: 59.93863,
                                                                             longitude: 30.270649,
                                                                             latitudeValue: "59.93863",
                                                                             longitudeValue: "30.270649")
                                                                ],
                                                                  kind: .attestation,
                                                                  contingentUnitName: nil,
                                                                  educatorIDs: [
                                                                    (2888, "Романовский И. В., профессор")
                                                                ],
                                                                  contingentUnitCourse: nil,
                                                                  contingentUnitDivision: nil,
                                                                  isAssigned: nil,
                                                                  timeWasChanged: nil,
                                                                  locationsWereChanged: nil,
                                                                  educatorsWereReassigned: nil)
                                                        ])
            ],
                                                educatorLongDisplayText: "Романовский Иосиф Владимирович",
                                                educatorID: 2888,
                                                from: dateFomatter.date(from: "2016-08-01T00:00:00")!,
                                                hasEvents: true,
                                                isSpringTerm: false,
                                                next: nil,
                                                springTermLinkAvailable: true,
                                                title: "Расписание преподавателя: Романовский Иосиф Владимирович",
                                                to: dateFomatter.date(from: "2017-02-01T00:00:00")!)
        
        // When
        let returnedScedule = try? EducatorSchedule(from: json)
        
        // Then
        XCTAssertEqual(expectedSchedule, returnedScedule)
    }

    func testInitializeAddressFromJSON() {

        // Given
        let jsonData = getTestingResource(fromFile: "addresses", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedAddress = Address(name: "Университетский просп., д. 28",
                                      matches: 112,
                                      wantingEquipment: nil,
                                      oid: "baf0eed7-4ef8-4e37-8dfb-df91d9021bd4")

        // When
        let returnedAddress = try? Address(from: json[2])

        // Then
        XCTAssertEqual(expectedAddress, returnedAddress)
    }

    func testInitializeRoomFromJSON() {

        // Given
        let jsonData = getTestingResource(fromFile: "address_baf0eed7-4ef8-4e37-8dfb-df91d9021bd4_locations",
                                          ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedRoom = Room(name: "2412",
                                seating: .theater,
                                capacity: 10,
                                additionalInfo: "Проектор, экран, аудио, Компьютерный класс ( 11 ПК )",
                                wantingEquipment: nil,
                                oid: "9939b803-25fa-4840-a066-08154738b47b")

        // When
        let returnedRoom = try? Room(from: json[3])

        // Then
        XCTAssertEqual(expectedRoom, returnedRoom)
    }

    // MARK: - Serialize-Deserialize

    func testSerializeDeserializeStudentGroup() {

        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studyprogram_5466_studentGroups", ofType: "json")!
        let timetable = Timetable()
        let initialJSON = JSON(data: jsonData)

        // When
        let deserializedObject = try? StudentGroup(from: initialJSON[0], bindingTo: timetable)
        let serializedJSON = deserializedObject.flatMap { JSON(data: $0.serialize()) }

        // Then
        XCTAssertNotNil(deserializedObject)
        XCTAssertNotNil(serializedJSON)
        XCTAssert(deserializedObject?.timetable === timetable)
        XCTAssertEqual(initialJSON[0], serializedJSON)
    }

    func testSerializeDeserializeWeek() {

        // Given
        let jsonData = getTestingResource(fromFile: "MATH_studentGroup_10014_events", ofType: "json")!
        let timetable = Timetable()
        let initialJSON = JSON(data: jsonData)

        // When
        let deserializedObject = try? Week(from: initialJSON, bindingTo: timetable)
        let serializedJSON = deserializedObject.flatMap { JSON(data: $0.serialize()) }

        // Then
        XCTAssertNotNil(deserializedObject)
        XCTAssertNotNil(serializedJSON)
        XCTAssert(deserializedObject?.timetable === timetable)
        XCTAssertEqual(initialJSON, serializedJSON)
    }
}
