import XCTest
import SwiftyJSON
import DefaultStringConvertible
@testable import TimetableSDK

class JSONTests: XCTestCase {
    
    func testInitializeDivisionFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "divisions", ofType: "json")!
        let json = JSON(data: jsonData)
        let expectedDivision = Division(name:  "Математика, Механика",
                                        alias: "MATH",
                                        oid:   "d92b7020-54be-431d-8b06-5aea117e5bfa")
        
        // When
        let returnedDivision = Division(from: json[7])
        
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
        let returnedStudyLevel = StudyLevel(from: json[0])
        
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
        let returnedStudentGroup = StudentGroup(from: json[0])
        
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
        let expectedWeek = Week(previousWeekMonday: dateFomatter.date(from: "2016-11-14")!,
                                nextWeekMonday: dateFomatter.date(from: "2016-11-28")!,
                                isPreviousWeekReferenceAvailable: true,
                                isNextWeekReferenceAvailable: true,
                                isCurrentWeekReferenceAvailable: false,
                                weekDisplayText: "21 ноября – 27 ноября",
                                days: [
                                    StudyDay(date: timeFormatter.date(from: "2016-11-21T00:00:00")!,
                                        name: "понедельник, 21 ноября",
                                        events: [
                                            StudyEvent(kind: nil,
                                                  locations: [
                                                    Location(educatorsDisplayText: "Евард М. Е., доцент",
                                                             hasEducators: true,
                                                             educatorIDs: [(2643, "Евард М. Е., доцент")],
                                                             isEmpty: false,
                                                             displayName: "Университетский просп., д. 28, 1510",
                                                             hasGeographicCoordinates: true,
                                                             latitude: 59.879785,
                                                             longitude: 29.829026,
                                                             latitudeValue: "59.879785",
                                                             longitudeValue: "29.829026")
                                                  ],
                                                  contingentUnitName: "",
                                                  educatorIDs: [(2643, "Евард М. Е., доцент")],
                                                  contingentUnitCourse: "",
                                                  contingentUnitDivision: "",
                                                  isAssigned: false,
                                                  timeWasChanged: false,
                                                  locationsWereChanged: false,
                                                  educatorsWereReassigned: false,
                                                  start: timeFormatter.date(from: "2016-11-21T09:30:00")!,
                                                  end: timeFormatter.date(from: "2016-11-21T11:05:00")!,
                                                  subject: "Механика деформируемого твердого тела, " +
                                                           "практическое занятие, факультатив",
                                                  timeIntervalString: "9:30–11:05",
                                                  dateWithTimeIntervalString: "21 ноября 9:30-11:05",
                                                  locationsDisplayText: "Университетский просп., д. 28, 1510",
                                                  educatorsDisplayText: "Евард М. Е., доцент",
                                                  hasEducators: true,
                                                  isCancelled: false,
                                                  hasTheSameTimeAsPreviousItem: false,
                                                  contingentUnitsDisplayText: nil,
                                                  isStudy: false,
                                                  allDay: false,
                                                  withinTheSameDay: false,
                                                  displayDateAndTimeIntervalString: "21 ноября 9:30-11:05")
                                        ])
                                ],
                                viewName: "Primary",
                                monday: dateFomatter.date(from: "2016-11-21")!,
                                studentGroupID: 10014,
                                studentGroupDisplayName: "Группа 351 (14.Б10-мм)",
                                timetableDisplayName: "Все занятия")
        
        // When
        let returnedWeek = Week(from: jsonData)
        
        // Then
        XCTAssertEqual(expectedWeek, returnedWeek)
    }
    
    func testInitializeBillboardFromJSON() {
        
        // Given
        let jsonData = getTestingResource(fromFile: "Billboard_events", ofType: "json")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let expectedBillboard =
            Billboard(alias: "Billboard",
                      days: [
                        BillboardDay(day: timeFormatter.date(from: "2016-11-28T00:00:00")!,
                                     events: [],
                                     dayString: "понедельник, 28 ноября")
                        ],
                      earlierEvents: [
                        BillboardEvent(allDay: true,
                                       contingentUnitsDisplayText: "",
                                       dateWithTimeIntervalString: "15.09 - 30.03",
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
                                       year: 2016)
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
        let returnedBillboard = Billboard(from: jsonData)
        
        // Then
        XCTAssertEqual(expectedBillboard, returnedBillboard)
    }
}
