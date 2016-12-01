//
//  StudyEvent.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// A study event. May represent lectures, workshops, exams, etc.
public struct StudyEvent : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
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
    
    public let kind: Kind?
    public let locations: [Location]
    public let contingentUnitName: String
    public let educatorIDs: [(Int, String)]
    public let contingentUnitCourse: String
    public let contingentUnitDivision: String
    public let isAssigned: Bool
    public let timeWasChanged: Bool
    public let locationsWereChanged: Bool
    public let educatorsWereReassigned: Bool
    public let start: Date
    public let end: Date
    public let subject: String
    public let timeIntervalString: String
    public let dateWithTimeIntervalString: String
    public let locationsDisplayText: String
    public let educatorsDisplayText: String
    public let hasEducators: Bool
    public let isCancelled: Bool
    public let hasTheSameTimeAsPreviousItem: Bool
    public let contingentUnitsDisplayText: String?
    public let isStudy: Bool
    public let allDay: Bool
    public let withinTheSameDay: Bool
    public let displayDateAndTimeIntervalString: String
    
    internal init(kind: Kind?,
                  locations: [Location],
                  contingentUnitName: String,
                  educatorIDs: [(Int, String)],
                  contingentUnitCourse: String,
                  contingentUnitDivision: String,
                  isAssigned: Bool,
                  timeWasChanged: Bool,
                  locationsWereChanged: Bool,
                  educatorsWereReassigned: Bool,
                  start: Date,
                  end: Date,
                  subject: String,
                  timeIntervalString: String,
                  dateWithTimeIntervalString: String,
                  locationsDisplayText: String,
                  educatorsDisplayText: String,
                  hasEducators: Bool,
                  isCancelled: Bool,
                  hasTheSameTimeAsPreviousItem: Bool,
                  contingentUnitsDisplayText: String?,
                  isStudy: Bool,
                  allDay: Bool,
                  withinTheSameDay: Bool,
                  displayDateAndTimeIntervalString: String) {
        self.kind = kind
        self.locations = locations
        self.contingentUnitName = contingentUnitName
        self.educatorIDs = educatorIDs
        self.contingentUnitCourse = contingentUnitCourse
        self.contingentUnitDivision = contingentUnitDivision
        self.isAssigned = isAssigned
        self.timeWasChanged = timeWasChanged
        self.locationsWereChanged = locationsWereChanged
        self.educatorsWereReassigned = educatorsWereReassigned
        self.start = start
        self.end = end
        self.subject = subject
        self.timeIntervalString = timeIntervalString
        self.dateWithTimeIntervalString = dateWithTimeIntervalString
        self.locationsDisplayText = locationsDisplayText
        self.educatorsDisplayText = educatorsDisplayText
        self.hasEducators = hasEducators
        self.isCancelled = isCancelled
        self.hasTheSameTimeAsPreviousItem = hasTheSameTimeAsPreviousItem
        self.contingentUnitsDisplayText = contingentUnitsDisplayText
        self.isStudy = isStudy
        self.allDay = allDay
        self.withinTheSameDay = withinTheSameDay
        self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
    }
    
    public init(from json: JSON) throws {
        kind                                = try map(json["StudyEventsTimeTableKindCode"],
                                                      transformation: Kind.init)
        locations                           = try map(json["EventLocations"])
        contingentUnitName                  = try map(json["ContingentUnitName"])
        educatorIDs                         = try map(json["EducatorIds"])
        contingentUnitCourse                = try map(json["ContingentUnitCourse"])
        contingentUnitDivision              = try map(json["ContingentUnitDivision"])
        isAssigned                          = try map(json["IsAssigned"])
        timeWasChanged                      = try map(json["TimeWasChanged"])
        locationsWereChanged                = try map(json["LocationsWereChanged"])
        educatorsWereReassigned             = try map(json["EducatorsWereReassigned"])
        start                               = try map(json["Start"],
                                                      transformation: StudyEvent.fullDateFormatter.date(from:))
        end                                 = try map(json["End"],
                                                      transformation: StudyEvent.fullDateFormatter.date(from:))
        subject                             = try map(json["Subject"])
        timeIntervalString                  = try map(json["TimeIntervalString"])
        dateWithTimeIntervalString          = try map(json["DateWithTimeIntervalString"])
        locationsDisplayText                = try map(json["LocationsDisplayText"])
        educatorsDisplayText                = try map(json["EducatorsDisplayText"])
        hasEducators                        = try map(json["HasEducators"])
        isCancelled                         = try map(json["IsCancelled"])
        hasTheSameTimeAsPreviousItem        = try map(json["HasTheSameTimeAsPreviousItem"])
        contingentUnitsDisplayText          = try map(json["ContingentUnitsDisplayTest"])
        isStudy                             = try map(json["IsStudy"])
        allDay                              = try map(json["AllDay"])
        withinTheSameDay                    = try map(json["WithinTheSameDay"])
        displayDateAndTimeIntervalString    = try map(json["DisplayDateAndTimeIntervalString"])
    }
}

public extension StudyEvent {
    
    public enum Kind: Int {
        case unknown = 0, primary, attestation, final
    }
}

extension StudyEvent: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: StudyEvent, rhs: StudyEvent) -> Bool {
        
        return
            lhs.kind                                == rhs.kind                             &&
            lhs.locations                           == rhs.locations                        &&
            lhs.contingentUnitName                  == rhs.contingentUnitName               &&
            zip(lhs.educatorIDs, rhs.educatorIDs).reduce(true, { $0 && $1.0 == $1.1 })      &&
            lhs.contingentUnitCourse                == rhs.contingentUnitCourse             &&
            lhs.contingentUnitDivision              == rhs.contingentUnitCourse             &&
            lhs.isAssigned                          == rhs.isAssigned                       &&
            lhs.timeWasChanged                      == rhs.timeWasChanged                   &&
            lhs.locationsWereChanged                == rhs.locationsWereChanged             &&
            lhs.educatorsWereReassigned             == rhs.educatorsWereReassigned          &&
            lhs.start                               == rhs.start                            &&
            lhs.end                                 == rhs.end                              &&
            lhs.subject                             == rhs.subject                          &&
            lhs.timeIntervalString                  == rhs.timeIntervalString               &&
            lhs.dateWithTimeIntervalString          == rhs.dateWithTimeIntervalString       &&
            lhs.locationsDisplayText                == rhs.locationsDisplayText             &&
            lhs.educatorsDisplayText                == rhs.educatorsDisplayText             &&
            lhs.hasEducators                        == rhs.hasEducators                     &&
            lhs.isCancelled                         == rhs.isCancelled                      &&
            lhs.hasTheSameTimeAsPreviousItem        == rhs.hasTheSameTimeAsPreviousItem     &&
            lhs.contingentUnitsDisplayText          == rhs.contingentUnitsDisplayText       &&
            lhs.isStudy                             == rhs.isStudy                          &&
            lhs.allDay                              == rhs.allDay                           &&
            lhs.withinTheSameDay                    == rhs.withinTheSameDay                 &&
            lhs.displayDateAndTimeIntervalString    == rhs.displayDateAndTimeIntervalString
    }
}

extension StudyEvent: CustomStringConvertible {}
