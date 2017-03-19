//
//  Science.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 04.12.2016.
//
//

import Foundation
import SwiftyJSON

/// The information about various scientific events taking place in the Univeristy.
public final class Science : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            eventGroupings.forEach { $0.timetable = timetable }
        }
    }
    
    internal static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    public let alias: String
    public let chosenMonthDisplayText: String
    public let eventGroupings: [EventGrouping]
    public let hasEventsToShow: Bool
    public let isCurrentMonthReferenceAvailable: Bool
    public let nextMonth: Date
    public let nextMonthDisplayText: String
    public let previousMonth: Date
    public let previousMonthDisplayText: String
    public let showGroupingCaptions: Bool
    public let title: String
    public let viewName: String
    
    internal init(alias: String,
                  chosenMonthDisplayText: String,
                  eventGroupings: [EventGrouping],
                  hasEventsToShow: Bool,
                  isCurrentMonthReferenceAvailable: Bool,
                  nextMonth: Date,
                  nextMonthDisplayText: String,
                  previousMonth: Date,
                  previousMonthDisplayText: String,
                  showGroupingCaptions: Bool,
                  title: String,
                  viewName: String) {
        self.alias                            = alias
        self.chosenMonthDisplayText           = chosenMonthDisplayText
        self.eventGroupings                   = eventGroupings
        self.hasEventsToShow                  = hasEventsToShow
        self.isCurrentMonthReferenceAvailable = isCurrentMonthReferenceAvailable
        self.nextMonth                        = nextMonth
        self.nextMonthDisplayText             = nextMonthDisplayText
        self.previousMonth                    = previousMonth
        self.previousMonthDisplayText         = previousMonthDisplayText
        self.showGroupingCaptions             = showGroupingCaptions
        self.title                            = title
        self.viewName                         = viewName
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            alias                            = try map(json["Alias"])
            chosenMonthDisplayText           = try map(json["ChosenMonthDisplayText"])
            eventGroupings                   = try map(json["EventGroupings"])
            hasEventsToShow                  = try map(json["HasEventsToShow"])
            isCurrentMonthReferenceAvailable = try map(json["IsCurrentMonthReferenceAvailable"])
            nextMonth                        = try map(json["NextMonthDate"],
                                                       transformation: Science.dateFormatter.date(from:))
            nextMonthDisplayText             = try map(json["NextMonthDisplayText"])
            previousMonth                    = try map(json["PreviousMonthDate"],
                                                       transformation: Science.dateFormatter.date(from:))
            previousMonthDisplayText         = try map(json["PreviousMonthDisplayText"])
            showGroupingCaptions             = try map(json["ShowGroupingCaptions"])
            title                            = try map(json["Title"])
            viewName                         = try map(json["ViewName"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Science.self)
        }
    }
}

extension Science : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Science, rhs: Science) -> Bool {
        return
            lhs.alias                               == rhs.alias                            &&
            lhs.chosenMonthDisplayText              == rhs.chosenMonthDisplayText           &&
            lhs.eventGroupings                      == rhs.eventGroupings                   &&
            lhs.hasEventsToShow                     == rhs.hasEventsToShow                  &&
            lhs.isCurrentMonthReferenceAvailable    == rhs.isCurrentMonthReferenceAvailable &&
            lhs.nextMonth                           == rhs.nextMonth                        &&
            lhs.nextMonthDisplayText                == rhs.nextMonthDisplayText             &&
            lhs.previousMonth                       == rhs.previousMonth                    &&
            lhs.previousMonthDisplayText            == rhs.previousMonthDisplayText         &&
            lhs.showGroupingCaptions                == rhs.showGroupingCaptions             &&
            lhs.title                               == rhs.title                            &&
            lhs.viewName                            == rhs.viewName
    }
}
