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
                                    Day(date: timeFormatter.date(from: "2016-11-21T00:00:00")!,
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
}
