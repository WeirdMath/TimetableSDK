//
//  Extracurricular.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON

/// The information about various events taking place in the Univeristy.
public final class Extracurricular : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            days.forEach { $0.timetable = timetable }
            earlierEvents.forEach { $0.timetable = timetable }
        }
    }
    
    internal static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = .posix
        return dateFormatter
    }()
    
    public let alias: String
    public let days: [Day]
    public let earlierEvents: [Event]
    public let hasEventsToShow: Bool
    public let isCurrentWeekReferenceAvailable: Bool
    public let isNextWeekReferenceAvailable: Bool
    public let isPreviousWeekReferenceAvailable: Bool
    public let nextWeekMonday: Date
    public let previousWeekMonday: Date
    public let title: String
    public let viewName: String
    public let weekDisplayText: String
    public let weekMonday: Date
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            alias                               = try map(json["Alias"])
            days                                = try map(json["Days"])
            earlierEvents                       = try map(json["EarlierEvents"])
            hasEventsToShow                     = try map(json["HasEventsToShow"])
            isCurrentWeekReferenceAvailable     = try map(json["IsCurrentWeekReferenceAvailable"])
            isNextWeekReferenceAvailable        = try map(json["IsNextWeekReferenceAvailable"])
            isPreviousWeekReferenceAvailable    = try map(json["IsPreviousWeekReferenceAvailable"])
            nextWeekMonday                      = try map(json["NextWeekMonday"],
                                                          transformation: Extracurricular
                                                            .dateFormatter
                                                            .date(from:))
            previousWeekMonday                  = try map(json["PreviousWeekMonday"],
                                                          transformation: Extracurricular
                                                            .dateFormatter
                                                            .date(from:))
            title                               = try map(json["Title"])
            viewName                            = try map(json["ViewName"])
            weekDisplayText                     = try map(json["WeekDisplayText"])
            weekMonday                          = try map(json["WeekMonday"],
                                                          transformation: Extracurricular
                                                            .dateFormatter
                                                            .date(from:))
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Extracurricular.self)
        }
    }
    
    internal init(alias: String,
                  days: [Day],
                  earlierEvents: [Event],
                  hasEventsToShow: Bool,
                  isCurrentWeekReferenceAvailable: Bool,
                  isNextWeekReferenceAvailable: Bool,
                  isPreviousWeekReferenceAvailable: Bool,
                  nextWeekMonday: Date,
                  previousWeekMonday: Date,
                  title: String,
                  viewName: String,
                  weekDisplayText: String,
                  weekMonday: Date) {
        
        self.alias                            = alias
        self.days                             = days
        self.earlierEvents                    = earlierEvents
        self.hasEventsToShow                  = hasEventsToShow
        self.isCurrentWeekReferenceAvailable  = isCurrentWeekReferenceAvailable
        self.isNextWeekReferenceAvailable     = isNextWeekReferenceAvailable
        self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        self.nextWeekMonday                   = nextWeekMonday
        self.previousWeekMonday               = previousWeekMonday
        self.title                            = title
        self.viewName                         = viewName
        self.weekDisplayText                  = weekDisplayText
        self.weekMonday                       = weekMonday
    }
}

extension Extracurricular: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Extracurricular, rhs: Extracurricular) -> Bool {
        return
            lhs.alias                               == rhs.alias                            &&
            lhs.days                                == rhs.days                             &&
            lhs.earlierEvents                       == rhs.earlierEvents                    &&
            lhs.hasEventsToShow                     == rhs.hasEventsToShow                  &&
            lhs.isCurrentWeekReferenceAvailable     == rhs.isCurrentWeekReferenceAvailable  &&
            lhs.isNextWeekReferenceAvailable        == rhs.isNextWeekReferenceAvailable     &&
            lhs.isPreviousWeekReferenceAvailable    == rhs.isPreviousWeekReferenceAvailable &&
            lhs.nextWeekMonday                      == rhs.nextWeekMonday                   &&
            lhs.previousWeekMonday                  == rhs.previousWeekMonday               &&
            lhs.title                               == rhs.title                            &&
            lhs.viewName                            == rhs.viewName                         &&
            lhs.weekDisplayText                     == rhs.weekDisplayText                  &&
            lhs.weekMonday                          == rhs.weekMonday
    }
}
