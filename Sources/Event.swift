//
//  Event.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// An event. May represent lectures, workshops, exams, activities, etc.
public final class Event : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            location?.timetable = timetable
            locations?.forEach { $0.timetable = timetable }
        }
    }
    
    fileprivate static let defaultDateFormatter: DateFormatter = {
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.dateFormat = "yyyy-MM-dd"
        return defaultDateFormatter
    }()
    
    fileprivate static let fullDateFormatter: DateFormatter = {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return fullDateFormatter
    }()
    
    fileprivate static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter
    }()
    
    public let allDay: Bool?
    public let contingentUnitsDisplayText: String?
    public let contingentUnitNames: [(String, String)]?
    public let dateWithTimeIntervalString: String?
    public let dates: [String]?
    public let displayDateAndTimeIntervalString: String?
    public let divisionAlias: String?
    public let educatorsDisplayText: String
    
    /// For an educator's schedule represents only time.
    public let end: Date
    public let fromDate: Date?
    public let fromDateString: String?
    public let fullDateWithTimeIntervalString: String?
    public let hasAgenda: Bool?
    public let hasEducators: Bool?
    public let hasTheSameTimeAsPreviousItem: Bool?
    public let id: Int?
    public let isCancelled: Bool?
    public let isEmpty: Bool?
    public let isRecurrence: Bool?
    public let isShowImmediateHidden: Bool?
    public let isStudy: Bool?
    public private(set) var location: Location?
    public let locationsDisplayText: String?
    public let orderIndex: Int?
    public let showImmediate: Bool?
    public let showYear: Bool?
    
    /// For an educator's schedule represents only time.
    public let start: Date
    public let subject: String
    public let subkindDisplayName: String?
    public let timeIntervalString: String
    public let viewKind: Int?
    public let withinTheSameDay: Bool?
    public let year: Int?
    public private(set) var locations: [Location]?
    public let kind: Kind?
    public let contingentUnitName: String?
    public let educatorIDs: [(Int, String)]?
    public let contingentUnitCourse: String?
    public let contingentUnitDivision: String?
    public let isAssigned: Bool?
    public let timeWasChanged: Bool?
    public let locationsWereChanged: Bool?
    public let educatorsWereReassigned: Bool?
    
    internal init(allDay: Bool?,
                  contingentUnitsDisplayText: String?,
                  contingentUnitNames: [(String, String)]?,
                  dateWithTimeIntervalString: String?,
                  dates: [String]?,
                  displayDateAndTimeIntervalString: String?,
                  divisionAlias: String?,
                  educatorsDisplayText: String,
                  end: Date,
                  fromDate: Date?,
                  fromDateString: String?,
                  fullDateWithTimeIntervalString: String?,
                  hasAgenda: Bool?,
                  hasEducators: Bool?,
                  hasTheSameTimeAsPreviousItem: Bool?,
                  id: Int?,
                  isCancelled: Bool?,
                  isEmpty: Bool?,
                  isRecurrence: Bool?,
                  isShowImmediateHidden: Bool?,
                  isStudy: Bool?,
                  location: Location?,
                  locationsDisplayText: String?,
                  orderIndex: Int?,
                  showImmediate: Bool?,
                  showYear: Bool?,
                  start: Date,
                  subject: String,
                  subkindDisplayName: String?,
                  timeIntervalString: String,
                  viewKind: Int?,
                  withinTheSameDay: Bool?,
                  year: Int?,
                  locations: [Location]?,
                  kind: Kind?,
                  contingentUnitName: String?,
                  educatorIDs: [(Int, String)]?,
                  contingentUnitCourse: String?,
                  contingentUnitDivision: String?,
                  isAssigned: Bool?,
                  timeWasChanged: Bool?,
                  locationsWereChanged: Bool?,
                  educatorsWereReassigned: Bool?) {
        self.allDay                           = allDay
        self.contingentUnitsDisplayText       = contingentUnitsDisplayText
        self.contingentUnitNames              = contingentUnitNames
        self.dateWithTimeIntervalString       = dateWithTimeIntervalString
        self.dates                            = dates
        self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
        self.divisionAlias                    = divisionAlias
        self.educatorsDisplayText             = educatorsDisplayText
        self.end                              = end
        self.fromDate                         = fromDate
        self.fromDateString                   = fromDateString
        self.fullDateWithTimeIntervalString   = fullDateWithTimeIntervalString
        self.hasAgenda                        = hasAgenda
        self.hasEducators                     = hasEducators
        self.hasTheSameTimeAsPreviousItem     = hasTheSameTimeAsPreviousItem
        self.id                               = id
        self.isCancelled                      = isCancelled
        self.isEmpty                          = isEmpty
        self.isRecurrence                     = isRecurrence
        self.isShowImmediateHidden            = isShowImmediateHidden
        self.isStudy                          = isStudy
        self.location                         = location
        self.locationsDisplayText             = locationsDisplayText
        self.orderIndex                       = orderIndex
        self.showImmediate                    = showImmediate
        self.showYear                         = showYear
        self.start                            = start
        self.subject                          = subject
        self.subkindDisplayName               = subkindDisplayName
        self.timeIntervalString               = timeIntervalString
        self.viewKind                         = viewKind
        self.withinTheSameDay                 = withinTheSameDay
        self.year                             = year
        self.locations                        = locations
        self.kind                             = kind
        self.contingentUnitName               = contingentUnitName
        self.educatorIDs                      = educatorIDs
        self.contingentUnitCourse             = contingentUnitCourse
        self.contingentUnitDivision           = contingentUnitDivision
        self.isAssigned                       = isAssigned
        self.timeWasChanged                   = timeWasChanged
        self.locationsWereChanged             = locationsWereChanged
        self.educatorsWereReassigned          = educatorsWereReassigned
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            allDay                              = try map(json["AllDay"])
            contingentUnitsDisplayText          = try map(json["ContingentUnitsDisplayTest"])
            contingentUnitNames                 = try map(json["ContingentUnitNames"])
            dateWithTimeIntervalString          = try map(json["DateWithTimeIntervalString"])
            dates                               = try map(json["Dates"])
            displayDateAndTimeIntervalString    = try map(json["DisplayDateAndTimeIntervalString"])
            divisionAlias                       = try map(json["DivisionAlias"])
            educatorsDisplayText                = try map(json["EducatorsDisplayText"])
            do {
                end                             = try map(json["End"],
                                                          transformation: Event.fullDateFormatter.date(from:))
            } catch {
                end                             = try map(json["End"],
                                                          transformation: Event.timeFormatter.date(from:))
            }
            fromDate                            = try map(json["FromDate"],
                                                          transformation: Event.fullDateFormatter.date(from:))
            fromDateString                      = try map(json["FromDateString"])
            fullDateWithTimeIntervalString      = try map(json["FullDateWithTimeIntervalString"])
            hasAgenda                           = try map(json["HasAgenda"])
            hasEducators                        = try map(json["HasEducators"])
            hasTheSameTimeAsPreviousItem        = try map(json["HasTheSameTimeAsPreviousItem"])
            id                                  = try map(json["Id"])
            do {
                isCancelled                     = try map(json["IsCancelled"]) as Bool
            } catch {
                isCancelled                     = try map(json["IsCanceled"])
            }
            isEmpty                             = try map(json["IsEmpty"])
            isRecurrence                        = try map(json["IsRecurrence"])
            isShowImmediateHidden               = try map(json["IsShowImmediateHidden"])
            isStudy                             = try map(json["IsStudy"])
            location                            = try map(json["Location"])
            locationsDisplayText                = try map(json["LocationsDisplayText"])
            orderIndex                          = try map(json["OrderIndex"])
            showImmediate                       = try map(json["ShowImmediate"])
            showYear                            = try map(json["ShowYear"])
            do {
                start                           = try map(json["Start"],
                                                          transformation: Event.fullDateFormatter.date(from:))
            } catch {
                start                           = try map(json["Start"],
                                                          transformation: Event.timeFormatter.date(from:))
            }
            subject                             = try map(json["Subject"])
            subkindDisplayName                  = try map(json["SubkindDisplayName"])
            timeIntervalString                  = try map(json["TimeIntervalString"])
            viewKind                            = try map(json["ViewKind"])
            withinTheSameDay                    = try map(json["WithinTheSameDay"])
            year                                = try map(json["Year"])
            locations                           = try map(json["EventLocations"])
            do {
                kind                            = try map(json["EventsTimeTableKindCode"],
                                                          transformation: Kind.init) as Kind
            } catch {
                kind                            = try map(json["StudyEventsTimeTableKindCode"],
                                                          transformation: Kind.init)
            }
            contingentUnitName                  = try map(json["ContingentUnitName"])
            educatorIDs                         = try map(json["EducatorIds"])
            contingentUnitCourse                = try map(json["ContingentUnitCourse"])
            contingentUnitDivision              = try map(json["ContingentUnitDivision"])
            isAssigned                          = try map(json["IsAssigned"])
            timeWasChanged                      = try map(json["TimeWasChanged"])
            locationsWereChanged                = try map(json["LocationsWereChanged"])
            educatorsWereReassigned             = try map(json["EducatorsWereReassigned"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Event.self)
        }
    }
}

public extension Event {
    
    public enum Kind: Int {
        case unknown = 0, primary, attestation, final
    }
}

extension Event: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Event, rhs: Event) -> Bool {
        
        return
            lhs.allDay                              == rhs.allDay                           &&
            lhs.contingentUnitsDisplayText          == rhs.contingentUnitsDisplayText       &&
            lhs.contingentUnitNames                 == rhs.contingentUnitNames              &&
            lhs.dateWithTimeIntervalString          == rhs.dateWithTimeIntervalString       &&
            lhs.dates                               == rhs.dates                            &&
            lhs.displayDateAndTimeIntervalString    == rhs.displayDateAndTimeIntervalString &&
            lhs.divisionAlias                       == rhs.divisionAlias                    &&
            lhs.educatorsDisplayText                == rhs.educatorsDisplayText             &&
            lhs.end                                 == rhs.end                              &&
            lhs.fromDate                            == rhs.fromDate                         &&
            lhs.fromDateString                      == rhs.fromDateString                   &&
            lhs.fullDateWithTimeIntervalString      == rhs.fullDateWithTimeIntervalString   &&
            lhs.hasAgenda                           == rhs.hasAgenda                        &&
            lhs.hasEducators                        == rhs.hasEducators                     &&
            lhs.hasTheSameTimeAsPreviousItem        == rhs.hasTheSameTimeAsPreviousItem     &&
            lhs.id                                  == rhs.id                               &&
            lhs.isCancelled                         == rhs.isCancelled                      &&
            lhs.isEmpty                             == rhs.isEmpty                          &&
            lhs.isRecurrence                        == rhs.isRecurrence                     &&
            lhs.isShowImmediateHidden               == rhs.isShowImmediateHidden            &&
            lhs.isStudy                             == rhs.isStudy                          &&
            lhs.location                            == rhs.location                         &&
            lhs.locationsDisplayText                == rhs.locationsDisplayText             &&
            lhs.orderIndex                          == rhs.orderIndex                       &&
            lhs.showImmediate                       == rhs.showImmediate                    &&
            lhs.showYear                            == rhs.showYear                         &&
            lhs.start                               == rhs.start                            &&
            lhs.subject                             == rhs.subject                          &&
            lhs.subkindDisplayName                  == rhs.subkindDisplayName               &&
            lhs.timeIntervalString                  == rhs.timeIntervalString               &&
            lhs.viewKind                            == rhs.viewKind                         &&
            lhs.withinTheSameDay                    == rhs.withinTheSameDay                 &&
            lhs.year                                == rhs.year                             &&
            lhs.locations                           == rhs.locations                        &&
            lhs.kind                                == rhs.kind                             &&
            lhs.contingentUnitName                  == rhs.contingentUnitName               &&
            lhs.educatorIDs                         == rhs.educatorIDs                      &&
            lhs.contingentUnitCourse                == rhs.contingentUnitCourse             &&
            lhs.contingentUnitDivision              == rhs.contingentUnitCourse             &&
            lhs.isAssigned                          == rhs.isAssigned                       &&
            lhs.timeWasChanged                      == rhs.timeWasChanged                   &&
            lhs.locationsWereChanged                == rhs.locationsWereChanged             &&
            lhs.educatorsWereReassigned             == rhs.educatorsWereReassigned
    }
}

extension Event: CustomStringConvertible {}
