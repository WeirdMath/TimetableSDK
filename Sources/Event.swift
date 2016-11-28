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
public struct StudyEvent {
    
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

public extension StudyEvent {
    
    public enum Kind: Int {
        case unknown = 0, primary, attestation, final
    }
}

extension StudyEvent: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.dateFormat = StudyEvent.defaultDateFormat
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = StudyEvent.fullDateFormat
        
        if let kind = json[StudyEvent.kindJSONKey].int {
            self.kind = Kind(rawValue: kind) ?? .unknown
        } else if json[StudyEvent.kindJSONKey].null != nil {
            self.kind = nil
        } else {
            jsonFailure(json: json, key: StudyEvent.kindJSONKey)
            return nil
        }
        
        if let locations = json[StudyEvent.locationsJSONKey].array?.flatMap(Location.init) {
            self.locations = locations
        } else {
            jsonFailure(json: json, key: StudyEvent.locationsJSONKey)
            return nil
        }
        
        if let contingentUnitName = json[StudyEvent.contingentUnitNameJSONKey].string {
            self.contingentUnitName = contingentUnitName
        } else {
            jsonFailure(json: json, key: StudyEvent.contingentUnitNameJSONKey)
            return nil
        }
        
        if let educatorIDs = json[StudyEvent.educatorIDsJSONKey]
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
            jsonFailure(json: json, key: StudyEvent.educatorIDsJSONKey)
            return nil
        }
        
        if let contingentUnitCourse = json[StudyEvent.contingentUnitCourseJSONKey].string {
            self.contingentUnitCourse = contingentUnitCourse
        } else {
            jsonFailure(json: json, key: StudyEvent.contingentUnitCourseJSONKey)
            return nil
        }
        
        if let contingentUnitDivision = json[StudyEvent.contingentUnitDivisionJSONKey].string {
            self.contingentUnitDivision = contingentUnitDivision
        } else {
            jsonFailure(json: json, key: StudyEvent.contingentUnitDivisionJSONKey)
            return nil
        }
        
        if let isAssigned = json[StudyEvent.isAssignedJSONKey].bool {
            self.isAssigned = isAssigned
        } else {
            jsonFailure(json: json, key: StudyEvent.isAssignedJSONKey)
            return nil
        }
        
        if let timeWasChanged = json[StudyEvent.timeWasChangedJSONKey].bool {
            self.timeWasChanged = timeWasChanged
        } else {
            jsonFailure(json: json, key: StudyEvent.timeWasChangedJSONKey)
            return nil
        }
        
        if let locationsWereChanged = json[StudyEvent.locationsWereChangedJSONKey].bool {
            self.locationsWereChanged = locationsWereChanged
        } else {
            jsonFailure(json: json, key: StudyEvent.locationsWereChangedJSONKey)
            return nil
        }
        
        if let educatorsWereReassigned = json[StudyEvent.educatorsWereReassignedJSONKey].bool {
            self.educatorsWereReassigned = educatorsWereReassigned
        } else {
            jsonFailure(json: json, key: StudyEvent.educatorsWereReassignedJSONKey)
            return nil
        }
        
        if let startString = json[StudyEvent.startJSONKey].string,
            let start = fullDateFormatter.date(from: startString) {
            self.start = start
        } else {
            jsonFailure(json: json, key: StudyEvent.startJSONKey)
            return nil
        }
        
        if let endString = json[StudyEvent.endJSONKey].string,
            let end = fullDateFormatter.date(from: endString) {
            self.end = end
        } else {
            jsonFailure(json: json, key: StudyEvent.endJSONKey)
            return nil
        }
        
        if let subject = json[StudyEvent.subjectJSONKey].string {
            self.subject = subject
        } else {
            jsonFailure(json: json, key: StudyEvent.subjectJSONKey)
            return nil
        }
        
        if let timeIntervalString = json[StudyEvent.timeIntervalStringJSONKey].string {
            self.timeIntervalString = timeIntervalString
        } else {
            jsonFailure(json: json, key: StudyEvent.timeIntervalStringJSONKey)
            return nil
        }
        
        if let dateWithTimeIntervalString = json[StudyEvent.dateWithTimeIntervalStringJSONKey].string {
            self.dateWithTimeIntervalString = dateWithTimeIntervalString
        } else {
            jsonFailure(json: json, key: StudyEvent.dateWithTimeIntervalStringJSONKey)
            return nil
        }
        
        if let locationsDisplayText = json[StudyEvent.locationsDisplayTextJSONKey].string {
            self.locationsDisplayText = locationsDisplayText
        } else {
            jsonFailure(json: json, key: StudyEvent.locationsDisplayTextJSONKey)
            return nil
        }
        
        if let educatorsDisplayText = json[StudyEvent.educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else {
            jsonFailure(json: json, key: StudyEvent.educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let hasEducators = json[StudyEvent.hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else {
            jsonFailure(json: json, key: StudyEvent.hasEducatorsJSONKey)
            return nil
        }
        
        if let isCancelled = json[StudyEvent.isCancelledJSONKey].bool {
            self.isCancelled = isCancelled
        } else {
            jsonFailure(json: json, key: StudyEvent.isCancelledJSONKey)
            return nil
        }
        
        if let hasTheSameTimeAsPreviousItem = json[StudyEvent.hasTheSameTimeAsPreviousItemJSONKey].bool {
            self.hasTheSameTimeAsPreviousItem = hasTheSameTimeAsPreviousItem
        } else {
            jsonFailure(json: json, key: StudyEvent.hasTheSameTimeAsPreviousItemJSONKey)
            return nil
        }
        
        if let contingentUnitsDisplayText = json[StudyEvent.contingentUnitsDisplayTextJSONKey].string {
            self.contingentUnitsDisplayText = contingentUnitsDisplayText
        } else if json[StudyEvent.contingentUnitsDisplayTextJSONKey].null != nil {
            self.contingentUnitsDisplayText = nil
        } else {
            jsonFailure(json: json, key: StudyEvent.contingentUnitsDisplayTextJSONKey)
            return nil
        }
        
        if let isStudy = json[StudyEvent.isStudyJSONKey].bool {
            self.isStudy = isStudy
        } else {
            jsonFailure(json: json, key: StudyEvent.isStudyJSONKey)
            return nil
        }
        
        if let allDay = json[StudyEvent.allDayJSONKey].bool {
            self.allDay = allDay
        } else {
            jsonFailure(json: json, key: StudyEvent.allDayJSONKey)
            return nil
        }
        
        if let withinTheSameDay = json[StudyEvent.withinTheSameDayJSONKey].bool {
            self.withinTheSameDay = withinTheSameDay
        } else {
            jsonFailure(json: json, key: StudyEvent.withinTheSameDayJSONKey)
            return nil
        }
        
        if let displayDateAndTimeIntervalString = json[StudyEvent.displayDateAndTimeIntervalStringJSONKey].string {
            self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
        } else {
            jsonFailure(json: json, key: StudyEvent.displayDateAndTimeIntervalStringJSONKey)
            return nil
        }
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
