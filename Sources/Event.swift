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

public struct Event {
    
    fileprivate static let _defaultDateFormat = "yyyy-MM-dd"
    fileprivate static let _fullDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public var kind: Kind?
    fileprivate static let _kindJSONKey = "StudyEventsTimeTableKindCode"
    
    public var locations: [Location]
    fileprivate static let _locationsJSONKey = "EventLocations"
    
    public var contingentUnitName: String
    fileprivate static let _contingentUnitNameJSONKey = "ContingentUnitName"
    
    public var educatorIDs: [(Int, String)]
    fileprivate static let _educatorIDsJSONKey = "EducatorIds"
    
    public var contingentUnitCourse: String
    fileprivate static let _contingentUnitCourseJSONKey = "ContingentUnitCourse"
    
    public var contingentUnitDivision: String
    fileprivate static let _contingentUnitDivisionJSONKey = "ContingentUnitDivision"
    
    public var isAssigned: Bool
    fileprivate static let _isAssignedJSONKey = "IsAssigned"
    
    public var timeWasChanged: Bool
    fileprivate static let _timeWasChangedJSONKey = "TimeWasChanged"
    
    public var locationsWereChanged: Bool
    fileprivate static let _locationsWereChangedJSONKey = "LocationsWereChanged"
    
    public var educatorsWereReassigned: Bool
    fileprivate static let _educatorsWereReassignedJSONKey = "EducatorsWereReassigned"
    
    public var start: Date
    fileprivate static let _startJSONKey = "Start"
    
    public var end: Date
    fileprivate static let _endJSONKey = "End"
    
    public var subject: String
    fileprivate static let _subjectJSONKey = "Subject"
    
    public var timeIntervalString: String
    fileprivate static let _timeIntervalStringJSONKey = "TimeIntervalString"
    
    public var dateWithTimeIntervalString: String
    fileprivate static let _dateWithTimeIntervalStringJSONKey = "DateWithTimeIntervalString"
    
    public var locationsDisplayText: String
    fileprivate static let _locationsDisplayTextJSONKey = "LocationsDisplayText"
    
    public var educatorsDisplayText: String
    fileprivate static let _educatorsDisplayTextJSONKey = "EducatorsDisplayText"
    
    public var hasEducators: Bool
    fileprivate static let _hasEducatorsJSONKey = "HasEducators"
    
    public var isCancelled: Bool
    fileprivate static let _isCancelledJSONKey = "IsCancelled"
    
    public var hasTheSameTimeAsPreviousItem: Bool
    fileprivate static let _hasTheSameTimeAsPreviousItemJSONKey = "HasTheSameTimeAsPreviousItem"
    
    public var contingentUnitsDisplayText: String?
    fileprivate static let _contingentUnitsDisplayTextJSONKey = "ContingentUnitsDisplayTest"
    
    public var isStudy: Bool
    fileprivate static let _isStudyJSONKey = "IsStudy"
    
    public var allDay: Bool
    fileprivate static let _allDayJSONKey = "AllDay"
    
    public var withinTheSameDay: Bool
    fileprivate static let _withinTheSameDayJSONKey = "WithinTheSameDay"
    
    public var displayDateAndTimeIntervalString: String
    fileprivate static let _displayDateAndTimeIntervalStringJSONKey = "DisplayDateAndTimeIntervalString"
}

extension Event {
    
    public enum Kind: Int {
        case unknown = 0, primary, attestation, final
    }
}

extension Event: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let defaultDateFormatter = DateFormatter()
        defaultDateFormatter.dateFormat = Event._defaultDateFormat
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = Event._fullDateFormat
        
        if let kind = json[Event._kindJSONKey].int {
            self.kind = Kind(rawValue: kind) ?? .unknown
        } else if json[Event._kindJSONKey].null != nil {
            self.kind = nil
        } else {
            _jsonFailure(json: json, key: Event._kindJSONKey)
            return nil
        }
        
        if let locations = json[Event._locationsJSONKey].array?.flatMap(Location.init) {
            self.locations = locations
        } else {
            _jsonFailure(json: json, key: Event._locationsJSONKey)
            return nil
        }
        
        if let contingentUnitName = json[Event._contingentUnitNameJSONKey].string {
            self.contingentUnitName = contingentUnitName
        } else {
            _jsonFailure(json: json, key: Event._contingentUnitNameJSONKey)
            return nil
        }
        
        if let educatorIDs = json[Event._educatorIDsJSONKey]
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
            _jsonFailure(json: json, key: Event._educatorIDsJSONKey)
            return nil
        }
        
        if let contingentUnitCourse = json[Event._contingentUnitCourseJSONKey].string {
            self.contingentUnitCourse = contingentUnitCourse
        } else {
            _jsonFailure(json: json, key: Event._contingentUnitCourseJSONKey)
            return nil
        }
        
        if let contingentUnitDivision = json[Event._contingentUnitDivisionJSONKey].string {
            self.contingentUnitDivision = contingentUnitDivision
        } else {
            _jsonFailure(json: json, key: Event._contingentUnitDivisionJSONKey)
            return nil
        }
        
        if let isAssigned = json[Event._isAssignedJSONKey].bool {
            self.isAssigned = isAssigned
        } else {
            _jsonFailure(json: json, key: Event._isAssignedJSONKey)
            return nil
        }
        
        if let timeWasChanged = json[Event._timeWasChangedJSONKey].bool {
            self.timeWasChanged = timeWasChanged
        } else {
            _jsonFailure(json: json, key: Event._timeWasChangedJSONKey)
            return nil
        }
        
        if let locationsWereChanged = json[Event._locationsWereChangedJSONKey].bool {
            self.locationsWereChanged = locationsWereChanged
        } else {
            _jsonFailure(json: json, key: Event._locationsWereChangedJSONKey)
            return nil
        }
        
        if let educatorsWereReassigned = json[Event._educatorsWereReassignedJSONKey].bool {
            self.educatorsWereReassigned = educatorsWereReassigned
        } else {
            _jsonFailure(json: json, key: Event._educatorsWereReassignedJSONKey)
            return nil
        }
        
        if let startString = json[Event._startJSONKey].string,
            let start = fullDateFormatter.date(from: startString) {
            self.start = start
        } else {
            _jsonFailure(json: json, key: Event._startJSONKey)
            return nil
        }
        
        if let endString = json[Event._endJSONKey].string,
            let end = fullDateFormatter.date(from: endString) {
            self.end = end
        } else {
            _jsonFailure(json: json, key: Event._endJSONKey)
            return nil
        }
        
        if let subject = json[Event._subjectJSONKey].string {
            self.subject = subject
        } else {
            _jsonFailure(json: json, key: Event._subjectJSONKey)
            return nil
        }
        
        if let timeIntervalString = json[Event._timeIntervalStringJSONKey].string {
            self.timeIntervalString = timeIntervalString
        } else {
            _jsonFailure(json: json, key: Event._timeIntervalStringJSONKey)
            return nil
        }
        
        if let dateWithTimeIntervalString = json[Event._dateWithTimeIntervalStringJSONKey].string {
            self.dateWithTimeIntervalString = dateWithTimeIntervalString
        } else {
            _jsonFailure(json: json, key: Event._dateWithTimeIntervalStringJSONKey)
            return nil
        }
        
        if let locationsDisplayText = json[Event._locationsDisplayTextJSONKey].string {
            self.locationsDisplayText = locationsDisplayText
        } else {
            _jsonFailure(json: json, key: Event._locationsDisplayTextJSONKey)
            return nil
        }
        
        if let educatorsDisplayText = json[Event._educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else {
            _jsonFailure(json: json, key: Event._educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let hasEducators = json[Event._hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else {
            _jsonFailure(json: json, key: Event._hasEducatorsJSONKey)
            return nil
        }
        
        if let isCancelled = json[Event._isCancelledJSONKey].bool {
            self.isCancelled = isCancelled
        } else {
            _jsonFailure(json: json, key: Event._isCancelledJSONKey)
            return nil
        }
        
        if let hasTheSameTimeAsPreviousItem = json[Event._hasTheSameTimeAsPreviousItemJSONKey].bool {
            self.hasTheSameTimeAsPreviousItem = hasTheSameTimeAsPreviousItem
        } else {
            _jsonFailure(json: json, key: Event._hasTheSameTimeAsPreviousItemJSONKey)
            return nil
        }
        
        if let contingentUnitsDisplayText = json[Event._contingentUnitsDisplayTextJSONKey].string {
            self.contingentUnitsDisplayText = contingentUnitsDisplayText
        } else if json[Event._contingentUnitsDisplayTextJSONKey].null != nil {
            self.contingentUnitsDisplayText = nil
        } else {
            _jsonFailure(json: json, key: Event._contingentUnitsDisplayTextJSONKey)
            return nil
        }
        
        if let isStudy = json[Event._isStudyJSONKey].bool {
            self.isStudy = isStudy
        } else {
            _jsonFailure(json: json, key: Event._isStudyJSONKey)
            return nil
        }
        
        if let allDay = json[Event._allDayJSONKey].bool {
            self.allDay = allDay
        } else {
            _jsonFailure(json: json, key: Event._allDayJSONKey)
            return nil
        }
        
        if let withinTheSameDay = json[Event._withinTheSameDayJSONKey].bool {
            self.withinTheSameDay = withinTheSameDay
        } else {
            _jsonFailure(json: json, key: Event._withinTheSameDayJSONKey)
            return nil
        }
        
        if let displayDateAndTimeIntervalString = json[Event._displayDateAndTimeIntervalStringJSONKey].string {
            self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
        } else {
            _jsonFailure(json: json, key: Event._displayDateAndTimeIntervalStringJSONKey)
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
