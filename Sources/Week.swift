//
//  Week.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

public struct Week {
    
    fileprivate static let _dateFormat = "yyyy-MM-dd"
    
    public let previousWeekMonday: Date
    fileprivate static let _previousWeekMondayJSONKey = "PreviousWeekMonday"
    
    public let nextWeekMonday: Date
    fileprivate static let _nextWeekMondayJSONKey = "NextWeekMonday"
    
    public let isPreviousWeekReferenceAvailable: Bool
    fileprivate static let _isPreviousWeekReferenceAvailableJSONKey = "IsPreviousWeekReferenceAvailable"
    
    public let isNextWeekReferenceAvailable: Bool
    fileprivate static let _isNextWeekReferenceAvailableJSONKey = "IsNextWeekReferenceAvailable"
    
    public let isCurrentWeekReferenceAvailable: Bool
    fileprivate static let _isCurrentWeekReferenceAvailableJSONKey = "IsCurrentWeekReferenceAvailable"
    
    public let weekDisplayText: String
    fileprivate static let _weekDisplayTextJSONKey = "WeekDisplayText"
    
    public let days: [Day]
    fileprivate static let _daysJSONKey = "Days"
    
    public let viewName: String
    fileprivate static let _viewNameJSONKey = "ViewName"
    
    public let monday: Date
    fileprivate static let _mondayJSONKey = "WeekMonday"
    
    public let studentGroupID: Int
    fileprivate static let _studentGroupIDJSONKey = "StudentGroupId"
    
    public let studentGroupDisplayName: String
    fileprivate static let _studentGroupDisplayNameJSONKey = "StudentGroupDisplayName"
    
    public let timetableDisplayName: String
    fileprivate static let _timeTableDisplayNameJSONKey = "TimeTableDisplayName"
}

extension Week: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Week._dateFormat
        
        if let previousWeekMondayString = json[Week._previousWeekMondayJSONKey].string,
            let previousWeekMonday = dateFormatter.date(from: previousWeekMondayString) {
            self.previousWeekMonday = previousWeekMonday
        } else {
            _jsonFailure(json: json, key: Week._previousWeekMondayJSONKey)
            return nil
        }
        
        if let nextWeekMondayString = json[Week._nextWeekMondayJSONKey].string,
            let nextWeekMonday = dateFormatter.date(from: nextWeekMondayString) {
            self.nextWeekMonday = nextWeekMonday
        } else {
            _jsonFailure(json: json, key: Week._nextWeekMondayJSONKey)
            return nil
        }
        
        if let isPreviousWeekReferenceAvailable = json[Week._isPreviousWeekReferenceAvailableJSONKey].bool {
            self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        } else {
            _jsonFailure(json: json, key: Week._isPreviousWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isNextWeekReferenceAvailable = json[Week._isNextWeekReferenceAvailableJSONKey].bool {
            self.isNextWeekReferenceAvailable = isNextWeekReferenceAvailable
        } else {
            _jsonFailure(json: json, key: Week._isNextWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isCurrentWeekReferenceAvailable = json[Week._isCurrentWeekReferenceAvailableJSONKey].bool {
            self.isCurrentWeekReferenceAvailable = isCurrentWeekReferenceAvailable
        } else {
            _jsonFailure(json: json, key: Week._isCurrentWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let weekDisplayText = json[Week._weekDisplayTextJSONKey].string {
            self.weekDisplayText = weekDisplayText
        } else {
            _jsonFailure(json: json, key: Week._weekDisplayTextJSONKey)
            return nil
        }
        
        if let days = json[Week._daysJSONKey].array?.flatMap(Day.init) {
            self.days = days
        } else {
            _jsonFailure(json: json, key: Week._daysJSONKey)
            return nil
        }
        
        if let viewName = json[Week._viewNameJSONKey].string {
            self.viewName = viewName
        } else {
            _jsonFailure(json: json, key: Week._viewNameJSONKey)
            return nil
        }
        
        if let mondayString = json[Week._mondayJSONKey].string,
            let monday = dateFormatter.date(from: mondayString) {
            self.monday = monday
        } else {
            _jsonFailure(json: json, key: Week._mondayJSONKey)
            return nil
        }
        
        if let studentGroupID = json[Week._studentGroupIDJSONKey].int {
            self.studentGroupID = studentGroupID
        } else {
            _jsonFailure(json: json, key: Week._studentGroupIDJSONKey)
            return nil
        }
        
        if let studentGroupDisplayName = json[Week._studentGroupDisplayNameJSONKey].string {
            self.studentGroupDisplayName = studentGroupDisplayName
        } else {
            _jsonFailure(json: json, key: Week._studentGroupDisplayNameJSONKey)
            return nil
        }
        
        if let timetableDisplayName = json[Week._timeTableDisplayNameJSONKey].string {
            self.timetableDisplayName = timetableDisplayName
        } else {
            _jsonFailure(json: json, key: Week._timeTableDisplayNameJSONKey)
            return nil
        }
    }
}

extension Week: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Week, rhs: Week) -> Bool {
        return
            lhs.previousWeekMonday                  == rhs.previousWeekMonday               &&
            lhs.nextWeekMonday                      == rhs.nextWeekMonday                   &&
            lhs.isPreviousWeekReferenceAvailable    == rhs.isPreviousWeekReferenceAvailable &&
            lhs.isNextWeekReferenceAvailable        == rhs.isNextWeekReferenceAvailable     &&
            lhs.isCurrentWeekReferenceAvailable     == rhs.isCurrentWeekReferenceAvailable  &&
            lhs.weekDisplayText                     == rhs.weekDisplayText                  &&
            lhs.days                                == rhs.days                             &&
            lhs.viewName                            == rhs.viewName                         &&
            lhs.monday                              == rhs.monday                           &&
            lhs.studentGroupID                      == rhs.studentGroupID                   &&
            lhs.studentGroupDisplayName             == rhs.studentGroupDisplayName          &&
            lhs.timetableDisplayName                == rhs.timetableDisplayName
    }
}

extension Week: CustomStringConvertible {}
