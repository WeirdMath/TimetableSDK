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

/// The information about a study week for a `StudentGroup`.
public struct Week {
    
    fileprivate static let dateFormat = "yyyy-MM-dd"
    
    public let previousWeekMonday: Date
    fileprivate static let previousWeekMondayJSONKey = "PreviousWeekMonday"
    
    public let nextWeekMonday: Date
    fileprivate static let nextWeekMondayJSONKey = "NextWeekMonday"
    
    public let isPreviousWeekReferenceAvailable: Bool
    fileprivate static let isPreviousWeekReferenceAvailableJSONKey = "IsPreviousWeekReferenceAvailable"
    
    public let isNextWeekReferenceAvailable: Bool
    fileprivate static let isNextWeekReferenceAvailableJSONKey = "IsNextWeekReferenceAvailable"
    
    public let isCurrentWeekReferenceAvailable: Bool
    fileprivate static let isCurrentWeekReferenceAvailableJSONKey = "IsCurrentWeekReferenceAvailable"
    
    public let weekDisplayText: String
    fileprivate static let weekDisplayTextJSONKey = "WeekDisplayText"
    
    public let days: [StudyDay]
    fileprivate static let daysJSONKey = "Days"
    
    public let viewName: String
    fileprivate static let viewNameJSONKey = "ViewName"
    
    public let monday: Date
    fileprivate static let mondayJSONKey = "WeekMonday"
    
    public let studentGroupID: Int
    fileprivate static let studentGroupIDJSONKey = "StudentGroupId"
    
    public let studentGroupDisplayName: String
    fileprivate static let studentGroupDisplayNameJSONKey = "StudentGroupDisplayName"
    
    public let timetableDisplayName: String
    fileprivate static let timeTableDisplayNameJSONKey = "TimeTableDisplayName"
}

extension Week: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Week.dateFormat
        
        if let previousWeekMondayString = json[Week.previousWeekMondayJSONKey].string,
            let previousWeekMonday = dateFormatter.date(from: previousWeekMondayString) {
            self.previousWeekMonday = previousWeekMonday
        } else {
            jsonFailure(json: json, key: Week.previousWeekMondayJSONKey)
            return nil
        }
        
        if let nextWeekMondayString = json[Week.nextWeekMondayJSONKey].string,
            let nextWeekMonday = dateFormatter.date(from: nextWeekMondayString) {
            self.nextWeekMonday = nextWeekMonday
        } else {
            jsonFailure(json: json, key: Week.nextWeekMondayJSONKey)
            return nil
        }
        
        if let isPreviousWeekReferenceAvailable = json[Week.isPreviousWeekReferenceAvailableJSONKey].bool {
            self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Week.isPreviousWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isNextWeekReferenceAvailable = json[Week.isNextWeekReferenceAvailableJSONKey].bool {
            self.isNextWeekReferenceAvailable = isNextWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Week.isNextWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isCurrentWeekReferenceAvailable = json[Week.isCurrentWeekReferenceAvailableJSONKey].bool {
            self.isCurrentWeekReferenceAvailable = isCurrentWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Week.isCurrentWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let weekDisplayText = json[Week.weekDisplayTextJSONKey].string {
            self.weekDisplayText = weekDisplayText
        } else {
            jsonFailure(json: json, key: Week.weekDisplayTextJSONKey)
            return nil
        }
        
        if let days = json[Week.daysJSONKey].array?.flatMap(StudyDay.init) {
            self.days = days
        } else {
            jsonFailure(json: json, key: Week.daysJSONKey)
            return nil
        }
        
        if let viewName = json[Week.viewNameJSONKey].string {
            self.viewName = viewName
        } else {
            jsonFailure(json: json, key: Week.viewNameJSONKey)
            return nil
        }
        
        if let mondayString = json[Week.mondayJSONKey].string,
            let monday = dateFormatter.date(from: mondayString) {
            self.monday = monday
        } else {
            jsonFailure(json: json, key: Week.mondayJSONKey)
            return nil
        }
        
        if let studentGroupID = json[Week.studentGroupIDJSONKey].int {
            self.studentGroupID = studentGroupID
        } else {
            jsonFailure(json: json, key: Week.studentGroupIDJSONKey)
            return nil
        }
        
        if let studentGroupDisplayName = json[Week.studentGroupDisplayNameJSONKey].string {
            self.studentGroupDisplayName = studentGroupDisplayName
        } else {
            jsonFailure(json: json, key: Week.studentGroupDisplayNameJSONKey)
            return nil
        }
        
        if let timetableDisplayName = json[Week.timeTableDisplayNameJSONKey].string {
            self.timetableDisplayName = timetableDisplayName
        } else {
            jsonFailure(json: json, key: Week.timeTableDisplayNameJSONKey)
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
