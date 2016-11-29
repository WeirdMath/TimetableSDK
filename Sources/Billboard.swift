//
//  Billboard.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

public struct Billboard : JSONRepresentable {
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    public let alias: String
    
    public let days: [BillboardDay]
    
    public let earlierEvents: [BillboardEvent]
    
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
}

extension Billboard {
    
    internal init(from json: JSON) throws {
        alias                               = try map(json["Alias"])
        days                                = try map(json["Days"])
        earlierEvents                       = try map(json["EarlierEvents"])
        hasEventsToShow                     = try map(json["HasEventsToShow"])
        isCurrentWeekReferenceAvailable     = try map(json["IsCurrentWeekReferenceAvailable"])
        isNextWeekReferenceAvailable        = try map(json["IsNextWeekReferenceAvailable"])
        isPreviousWeekReferenceAvailable    = try map(json["IsPreviousWeekReferenceAvailable"])
        nextWeekMonday                      = try map(json["NextWeekMonday"],
                                                      transformation: Billboard.dateFormatter.date(from:))
        previousWeekMonday                  = try map(json["PreviousWeekMonday"],
                                                      transformation: Billboard.dateFormatter.date(from:))
        title                               = try map(json["Title"])
        viewName                            = try map(json["ViewName"])
        weekDisplayText                     = try map(json["WeekDisplayText"])
        weekMonday                          = try map(json["WeekMonday"],
                                                      transformation: Billboard.dateFormatter.date(from:))
    }
}

extension Billboard: Equatable {
    
    public static func ==(lhs: Billboard, rhs: Billboard) -> Bool {
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

extension Billboard: CustomStringConvertible {}
