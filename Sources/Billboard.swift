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

public struct Billboard {
    
    fileprivate static let dateFormat = "yyyy-MM-dd"
    
    public let alias: String
    fileprivate static let aliasJSONKey = "Alias"
    
    public let days: [BillboardDay]
    fileprivate static let daysJSONKey = "Days"
    
    public let earlierEvents: [BillboardEvent]
    fileprivate static let earlierEventsJSONKey = "EarlierEvents"
    
    public let hasEventsToShow: Bool
    fileprivate static let hasEventsToShowJSONKey = "HasEventsToShow"
    
    public let isCurrentWeekReferenceAvailable: Bool
    fileprivate static let isCurrentWeekReferenceAvailableJSONKey = "IsCurrentWeekReferenceAvailable"
    
    public let isNextWeekReferenceAvailable: Bool
    fileprivate static let isNextWeekReferenceAvailableJSONKey = "IsNextWeekReferenceAvailable"
    
    public let isPreviousWeekReferenceAvailable: Bool
    fileprivate static let isPreviousWeekReferenceAvailableJSONKey = "IsPreviousWeekReferenceAvailable"
    
    public let nextWeekMonday: Date
    fileprivate static let nextWeekMondayJSONKey = "NextWeekMonday"
    
    public let previousWeekMonday: Date
    fileprivate static let previousWeekMondayJSONKey = "PreviousWeekMonday"
    
    public let title: String
    fileprivate static let titleJSONKey = "Title"
    
    public let viewName: String
    fileprivate static let viewNameJSONKey = "ViewName"
    
    public let weekDisplayText: String
    fileprivate static let weekDisplayTextJSONKey = "WeekDisplayText"
    
    public let weekMonday: Date
    fileprivate static let weekMondayJSONKey = "WeekMonday"
}

extension Billboard: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Billboard.dateFormat
        
        if let alias = json[Billboard.aliasJSONKey].string {
            self.alias = alias
        } else {
            jsonFailure(json: json, key: Billboard.aliasJSONKey)
            return nil
        }
        
        if let days = json[Billboard.daysJSONKey].array?.flatMap(BillboardDay.init) {
            self.days = days
        } else {
            jsonFailure(json: json, key: Billboard.daysJSONKey)
            return nil
        }
        
        if let earlierEvents = json[Billboard.earlierEventsJSONKey].array?.flatMap(BillboardEvent.init) {
            self.earlierEvents = earlierEvents
        } else {
            jsonFailure(json: json, key: Billboard.earlierEventsJSONKey)
            return nil
        }
        
        if let hasEventsToShow = json[Billboard.hasEventsToShowJSONKey].bool {
            self.hasEventsToShow = hasEventsToShow
        } else {
            jsonFailure(json: json, key: Billboard.hasEventsToShowJSONKey)
            return nil
        }
        
        if let isCurrentWeekReferenceAvailable = json[Billboard.isCurrentWeekReferenceAvailableJSONKey].bool {
            self.isCurrentWeekReferenceAvailable = isCurrentWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Billboard.isCurrentWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isNextWeekReferenceAvailable = json[Billboard.isNextWeekReferenceAvailableJSONKey].bool {
            self.isNextWeekReferenceAvailable = isNextWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Billboard.isNextWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let isPreviousWeekReferenceAvailable = json[Billboard.isPreviousWeekReferenceAvailableJSONKey].bool {
            self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        } else {
            jsonFailure(json: json, key: Billboard.isPreviousWeekReferenceAvailableJSONKey)
            return nil
        }
        
        if let nextWeekMondayString = json[Billboard.nextWeekMondayJSONKey].string,
            let nextWeekMonday = dateFormatter.date(from: nextWeekMondayString) {
            self.nextWeekMonday = nextWeekMonday
        } else {
            jsonFailure(json: json, key: Billboard.nextWeekMondayJSONKey)
            return nil
        }
        
        if let previousWeekMondayString = json[Billboard.previousWeekMondayJSONKey].string,
            let previousWeekMonday = dateFormatter.date(from: previousWeekMondayString){
            self.previousWeekMonday = previousWeekMonday
        } else {
            jsonFailure(json: json, key: Billboard.previousWeekMondayJSONKey)
            return nil
        }
        
        if let title = json[Billboard.titleJSONKey].string {
            self.title = title
        } else {
            jsonFailure(json: json, key: Billboard.titleJSONKey)
            return nil
        }
        
        if let viewName = json[Billboard.viewNameJSONKey].string {
            self.viewName = viewName
        } else {
            jsonFailure(json: json, key: Billboard.viewNameJSONKey)
            return nil
        }
        
        if let weekDisplayText = json[Billboard.weekDisplayTextJSONKey].string {
            self.weekDisplayText = weekDisplayText
        } else {
            jsonFailure(json: json, key: Billboard.weekDisplayTextJSONKey)
            return nil
        }
        
        if let weekMondayString = json[Billboard.weekMondayJSONKey].string,
            let weekMonday = dateFormatter.date(from: weekMondayString) {
            self.weekMonday = weekMonday
        } else {
            jsonFailure(json: json, key: Billboard.weekMondayJSONKey)
            return nil
        }
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
