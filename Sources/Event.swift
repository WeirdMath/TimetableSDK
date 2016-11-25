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

/// A study event. May represent lectures, workshops, exams, etc.
public struct Event {
    
    fileprivate static let defaultDateFormat = "yyyy-MM-dd"
    fileprivate static let fullDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public let kind: Kind?
    fileprivate static let kindJSONKey = "StudyEventsTimeTableKindCode"
    
    public let locations: [Location]
    fileprivate static let locationsJSONKey = "EventLocations"
    
    public let contingentUnitName: String
    fileprivate static let contingentUnitNameJSONKey = "ContingentUnitName"
    
    public let educatorIDs: [(Int, String)]
    fileprivate static let educatorIDsJSONKey = "EducatorIds"
    
    public let contingentUnitCourse: String
    fileprivate static let contingentUnitCourseJSONKey = "ContingentUnitCourse"
    
    public let contingentUnitDivision: String
    fileprivate static let contingentUnitDivisionJSONKey = "ContingentUnitDivision"
    
    public let isAssigned: Bool
    fileprivate static let isAssignedJSONKey = "IsAssigned"
    
    public let timeWasChanged: Bool
    fileprivate static let timeWasChangedJSONKey = "TimeWasChanged"
    
    public let locationsWereChanged: Bool
    fileprivate static let locationsWereChangedJSONKey = "LocationsWereChanged"
    
    public let educatorsWereReassigned: Bool
    fileprivate static let educatorsWereReassignedJSONKey = "EducatorsWereReassigned"
    
    public let start: Date
    fileprivate static let startJSONKey = "Start"
    
    public let end: Date
    fileprivate static let endJSONKey = "End"
    
    public let subject: String
    fileprivate static let subjectJSONKey = "Subject"
    
    public let timeIntervalString: String
    fileprivate static let timeIntervalStringJSONKey = "TimeIntervalString"
    
    public let dateWithTimeIntervalString: String
    fileprivate static let dateWithTimeIntervalStringJSONKey = "DateWithTimeIntervalString"
    
    public let locationsDisplayText: String
    fileprivate static let locationsDisplayTextJSONKey = "LocationsDisplayText"
    
    public let educatorsDisplayText: String
    fileprivate static let educatorsDisplayTextJSONKey = "EducatorsDisplayText"
    
    public let hasEducators: Bool
    fileprivate static let hasEducatorsJSONKey = "HasEducators"
    
    public let isCancelled: Bool
    fileprivate static let isCancelledJSONKey = "IsCancelled"
    
    public let hasTheSameTimeAsPreviousItem: Bool
    fileprivate static let hasTheSameTimeAsPreviousItemJSONKey = "HasTheSameTimeAsPreviousItem"
    
    public let contingentUnitsDisplayText: String?
    fileprivate static let contingentUnitsDisplayTextJSONKey = "ContingentUnitsDisplayTest"
    
    public let isStudy: Bool
    fileprivate static let isStudyJSONKey = "IsStudy"
    
    public let allDay: Bool
    fileprivate static let allDayJSONKey = "AllDay"
    
    public let withinTheSameDay: Bool
    fileprivate static let withinTheSameDayJSONKey = "WithinTheSameDay"
    
    public let displayDateAndTimeIntervalString: String
    fileprivate static let displayDateAndTimeIntervalStringJSONKey = "DisplayDateAndTimeIntervalString"
}

public extension Event {
    
    public enum Kind: Int {
        case unknown = 0, primary, attestation, final
    }
}

extension Event: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.dateFormat = Event.defaultDateFormat
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = Event.fullDateFormat
        
        if let kind = json[Event.kindJSONKey].int {
            self.kind = Kind(rawValue: kind) ?? .unknown
        } else if json[Event.kindJSONKey].null != nil {
            self.kind = nil
        } else {
            jsonFailure(json: json, key: Event.kindJSONKey)
            return nil
        }
        
        if let locations = json[Event.locationsJSONKey].array?.flatMap(Location.init) {
            self.locations = locations
        } else {
            jsonFailure(json: json, key: Event.locationsJSONKey)
            return nil
        }
        
        if let contingentUnitName = json[Event.contingentUnitNameJSONKey].string {
            self.contingentUnitName = contingentUnitName
        } else {
            jsonFailure(json: json, key: Event.contingentUnitNameJSONKey)
            return nil
        }
        
        if let educatorIDs = json[Event.educatorIDsJSONKey]
            .array?
            .flatMap({ (tuple: JSON) -> (Int, String)? in
                if let id = tuple["Item1"].int,
                    let name = tuple["Item2"].string {
                    return (id, name)
                } else {
                    return nil
                }
            }) {
            
            self.educatorIDs = educatorIDs
        } else {
            jsonFailure(json: json, key: Event.educatorIDsJSONKey)
            return nil
        }
        
        if let contingentUnitCourse = json[Event.contingentUnitCourseJSONKey].string {
            self.contingentUnitCourse = contingentUnitCourse
        } else {
            jsonFailure(json: json, key: Event.contingentUnitCourseJSONKey)
            return nil
        }
        
        if let contingentUnitDivision = json[Event.contingentUnitDivisionJSONKey].string {
            self.contingentUnitDivision = contingentUnitDivision
        } else {
            jsonFailure(json: json, key: Event.contingentUnitDivisionJSONKey)
            return nil
        }
        
        if let isAssigned = json[Event.isAssignedJSONKey].bool {
            self.isAssigned = isAssigned
        } else {
            jsonFailure(json: json, key: Event.isAssignedJSONKey)
            return nil
        }
        
        if let timeWasChanged = json[Event.timeWasChangedJSONKey].bool {
            self.timeWasChanged = timeWasChanged
        } else {
            jsonFailure(json: json, key: Event.timeWasChangedJSONKey)
            return nil
        }
        
        if let locationsWereChanged = json[Event.locationsWereChangedJSONKey].bool {
            self.locationsWereChanged = locationsWereChanged
        } else {
            jsonFailure(json: json, key: Event.locationsWereChangedJSONKey)
            return nil
        }
        
        if let educatorsWereReassigned = json[Event.educatorsWereReassignedJSONKey].bool {
            self.educatorsWereReassigned = educatorsWereReassigned
        } else {
            jsonFailure(json: json, key: Event.educatorsWereReassignedJSONKey)
            return nil
        }
        
        if let startString = json[Event.startJSONKey].string,
            let start = fullDateFormatter.date(from: startString) {
            self.start = start
        } else {
            jsonFailure(json: json, key: Event.startJSONKey)
            return nil
        }
        
        if let endString = json[Event.endJSONKey].string,
            let end = fullDateFormatter.date(from: endString) {
            self.end = end
        } else {
            jsonFailure(json: json, key: Event.endJSONKey)
            return nil
        }
        
        if let subject = json[Event.subjectJSONKey].string {
            self.subject = subject
        } else {
            jsonFailure(json: json, key: Event.subjectJSONKey)
            return nil
        }
        
        if let timeIntervalString = json[Event.timeIntervalStringJSONKey].string {
            self.timeIntervalString = timeIntervalString
        } else {
            jsonFailure(json: json, key: Event.timeIntervalStringJSONKey)
            return nil
        }
        
        if let dateWithTimeIntervalString = json[Event.dateWithTimeIntervalStringJSONKey].string {
            self.dateWithTimeIntervalString = dateWithTimeIntervalString
        } else {
            jsonFailure(json: json, key: Event.dateWithTimeIntervalStringJSONKey)
            return nil
        }
        
        if let locationsDisplayText = json[Event.locationsDisplayTextJSONKey].string {
            self.locationsDisplayText = locationsDisplayText
        } else {
            jsonFailure(json: json, key: Event.locationsDisplayTextJSONKey)
            return nil
        }
        
        if let educatorsDisplayText = json[Event.educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else {
            jsonFailure(json: json, key: Event.educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let hasEducators = json[Event.hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else {
            jsonFailure(json: json, key: Event.hasEducatorsJSONKey)
            return nil
        }
        
        if let isCancelled = json[Event.isCancelledJSONKey].bool {
            self.isCancelled = isCancelled
        } else {
            jsonFailure(json: json, key: Event.isCancelledJSONKey)
            return nil
        }
        
        if let hasTheSameTimeAsPreviousItem = json[Event.hasTheSameTimeAsPreviousItemJSONKey].bool {
            self.hasTheSameTimeAsPreviousItem = hasTheSameTimeAsPreviousItem
        } else {
            jsonFailure(json: json, key: Event.hasTheSameTimeAsPreviousItemJSONKey)
            return nil
        }
        
        if let contingentUnitsDisplayText = json[Event.contingentUnitsDisplayTextJSONKey].string {
            self.contingentUnitsDisplayText = contingentUnitsDisplayText
        } else if json[Event.contingentUnitsDisplayTextJSONKey].null != nil {
            self.contingentUnitsDisplayText = nil
        } else {
            jsonFailure(json: json, key: Event.contingentUnitsDisplayTextJSONKey)
            return nil
        }
        
        if let isStudy = json[Event.isStudyJSONKey].bool {
            self.isStudy = isStudy
        } else {
            jsonFailure(json: json, key: Event.isStudyJSONKey)
            return nil
        }
        
        if let allDay = json[Event.allDayJSONKey].bool {
            self.allDay = allDay
        } else {
            jsonFailure(json: json, key: Event.allDayJSONKey)
            return nil
        }
        
        if let withinTheSameDay = json[Event.withinTheSameDayJSONKey].bool {
            self.withinTheSameDay = withinTheSameDay
        } else {
            jsonFailure(json: json, key: Event.withinTheSameDayJSONKey)
            return nil
        }
        
        if let displayDateAndTimeIntervalString = json[Event.displayDateAndTimeIntervalStringJSONKey].string {
            self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
        } else {
            jsonFailure(json: json, key: Event.displayDateAndTimeIntervalStringJSONKey)
            return nil
        }
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

extension Event: CustomStringConvertible {}
