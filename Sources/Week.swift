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
public final class Week : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    fileprivate static let dateForatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    public let previousWeekMonday: Date
    public let nextWeekMonday: Date
    public let isPreviousWeekReferenceAvailable: Bool
    public let isNextWeekReferenceAvailable: Bool
    public let isCurrentWeekReferenceAvailable: Bool
    public let weekDisplayText: String
    public let days: [StudyDay]
    public let viewName: String
    public let monday: Date
    public let studentGroupID: Int
    public let studentGroupDisplayName: String
    public let timetableDisplayName: String
    
    internal init(previousWeekMonday: Date,
                  nextWeekMonday: Date,
                  isPreviousWeekReferenceAvailable: Bool,
                  isNextWeekReferenceAvailable: Bool,
                  isCurrentWeekReferenceAvailable: Bool,
                  weekDisplayText: String,
                  days: [StudyDay],
                  viewName: String,
                  monday: Date,
                  studentGroupID: Int,
                  studentGroupDisplayName: String,
                  timetableDisplayName: String) {
        self.previousWeekMonday               = previousWeekMonday
        self.nextWeekMonday                   = nextWeekMonday
        self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        self.isNextWeekReferenceAvailable     = isNextWeekReferenceAvailable
        self.isCurrentWeekReferenceAvailable  = isCurrentWeekReferenceAvailable
        self.weekDisplayText                  = weekDisplayText
        self.days                             = days
        self.viewName                         = viewName
        self.monday                           = monday
        self.studentGroupID                   = studentGroupID
        self.studentGroupDisplayName          = studentGroupDisplayName
        self.timetableDisplayName             = timetableDisplayName
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            previousWeekMonday                  = try map(json["PreviousWeekMonday"],
                                                          transformation: Week.dateForatter.date(from:))
            nextWeekMonday                      = try map(json["NextWeekMonday"],
                                                          transformation: Week.dateForatter.date(from:))
            isPreviousWeekReferenceAvailable    = try map(json["IsPreviousWeekReferenceAvailable"])
            isNextWeekReferenceAvailable        = try map(json["IsNextWeekReferenceAvailable"])
            isCurrentWeekReferenceAvailable     = try map(json["IsCurrentWeekReferenceAvailable"])
            weekDisplayText                     = try map(json["WeekDisplayText"])
            days                                = try map(json["Days"])
            viewName                            = try map(json["ViewName"])
            monday                              = try map(json["WeekMonday"],
                                                          transformation: Week.dateForatter.date(from:))
            studentGroupID                      = try map(json["StudentGroupId"])
            studentGroupDisplayName             = try map(json["StudentGroupDisplayName"])
            timetableDisplayName                = try map(json["TimeTableDisplayName"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Week.self)
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
