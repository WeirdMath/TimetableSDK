//
//  BillboardEvent.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON

public struct BillboardEvent {
    
    fileprivate static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public let allDay: Bool
    fileprivate static let allDayJSONKey = "AllDay"
    
    public let contingentUnitsDisplayText: String
    fileprivate static let contingentUnitsDisplayTextJSONKey = "ContingentUnitsDisplayTest"
    
    public let dateWithTimeIntervalString: String
    fileprivate static let dateWithTimeIntervalStringJSONKey = "DateWithTimeIntervalString"
    
    public let displayDateAndTimeIntervalString: String
    fileprivate static let displayDateAndTimeIntervalStringJSONKey = "DisplayDateAndTimeIntervalString"
    
    public let divisionAlias: String
    fileprivate static let divisionAliasJSONKey = "DivisionAlias"
    
    public let educatorsDisplayText: String
    fileprivate static let educatorsDisplayTextJSONKey = "EducatorsDisplayText"
    
    public let end: Date
    fileprivate static let endJSONKey = "End"
    
    public let fromDate: Date
    fileprivate static let fromDateJSONKey = "FromDate"
    
    public let fromDateString: String
    fileprivate static let fromDateStringJSONKey = "FromDateString"
    
    public let fullDateWithTimeIntervalString: String
    fileprivate static let fullDateWithTimeIntervalStringJSONKey = "FullDateWithTimeIntervalString"
    
    public let hasAgenda: Bool
    fileprivate static let hasAgendaJSONKey = "HasAgenda"
    
    public let hasEducators: Bool
    fileprivate static let hasEducatorsJSONKey = "HasEducators"
    
    public let hasTheSameTimeAsPreviousItem: Bool
    fileprivate static let hasTheSameTimeAsPreviousItemJSONKey = "HasTheSameTimeAsPreviousItem"
    
    public let id: Int
    fileprivate static let idJSONKey = "Id"
    
    public let isCancelled: Bool
    fileprivate static let isCancelledJSONKey = "IsCancelled"
    
    public let isEmpty: Bool
    fileprivate static let isEmptyJSONKey = "IsEmpty"
    
    public let isRecurrence: Bool
    fileprivate static let isRecurrenceJSONKey = "IsRecurrence"
    
    public let isShowImmediateHidden: Bool
    fileprivate static let isShowImmediateHiddenJSONKey = "IsShowImmediateHidden"
    
    public let isStudy: Bool
    fileprivate static let isStudyJSONKey = "IsStudy"
    
    public let location: Location
    fileprivate static let locationJSONKey = "Location"
    
    public let locationsDisplayText: String
    fileprivate static let locationsDisplayTextJSONKey = "LocationsDisplayText"
    
    public let orderIndex: Int
    fileprivate static let orderIndexJSONKey = "OrderIndex"

    public let showImmediate: Bool
    fileprivate static let showImmediateJSONKey = "ShowImmediate"
    
    public let showYear: Bool
    fileprivate static let showYearJSONKey = "ShowYear"
    
    public let start: Date
    fileprivate static let startJSONKey = "Start"
    
    public let subject: String
    fileprivate static let subjectJSONKey = "Subject"
    
    public let subkindDisplayName: String
    fileprivate static let subkindDisplayNameJSONKey = "SubkindDisplayName"
    
    public let timeIntervalString: String
    fileprivate static let timeIntervalStringJSONKey = "TimeIntervalString"
    
    public let viewKind: Int
    fileprivate static let viewKindJSONKey = "ViewKind"
    
    public let withinTheSameDay: Bool
    fileprivate static let withinTheSameDayJSONKey = "WithinTheSameDay"
    
    public let year: Int
    fileprivate static let yearJSONKey = "Year"
}

extension BillboardEvent: JSONRepresentable {
    
    init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = BillboardEvent.dateFormat
        
        if let allDay = json[BillboardEvent.allDayJSONKey].bool {
            self.allDay = allDay
        } else {
            jsonFailure(json: json, key: BillboardEvent.allDayJSONKey)
            return nil
        }
        
        if let contingentUnitsDisplayText = json[BillboardEvent.contingentUnitsDisplayTextJSONKey].string {
            self.contingentUnitsDisplayText = contingentUnitsDisplayText
        } else {
            jsonFailure(json: json, key: BillboardEvent.contingentUnitsDisplayTextJSONKey)
            return nil
        }
        
        if let dateWithTimeIntervalString = json[BillboardEvent.dateWithTimeIntervalStringJSONKey].string {
            self.dateWithTimeIntervalString = dateWithTimeIntervalString
        } else {
            jsonFailure(json: json, key: BillboardEvent.dateWithTimeIntervalStringJSONKey)
            return nil
        }
        
        if let displayDateAndTimeIntervalString =
            json[BillboardEvent.displayDateAndTimeIntervalStringJSONKey].string {
            self.displayDateAndTimeIntervalString = displayDateAndTimeIntervalString
        } else {
            jsonFailure(json: json, key: BillboardEvent.displayDateAndTimeIntervalStringJSONKey)
            return nil
        }
        
        if let divisionAlias = json[BillboardEvent.divisionAliasJSONKey].string {
            self.divisionAlias = divisionAlias
        } else {
            jsonFailure(json: json, key: BillboardEvent.divisionAliasJSONKey)
            return nil
        }
        
        if let educatorsDisplayText = json[BillboardEvent.educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else {
            jsonFailure(json: json, key: BillboardEvent.educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let endString = json[BillboardEvent.endJSONKey].string,
            let end = dateFormatter.date(from: endString) {
            self.end = end
        } else {
            jsonFailure(json: json, key: BillboardEvent.endJSONKey)
            return nil
        }
        
        if let fromDateString = json[BillboardEvent.fromDateJSONKey].string,
            let fromDate = dateFormatter.date(from: fromDateString) {
            self.fromDate = fromDate
        } else {
            jsonFailure(json: json, key: BillboardEvent.fromDateJSONKey)
            return nil
        }
        
        if let fromDateString = json[BillboardEvent.fromDateStringJSONKey].string {
            self.fromDateString = fromDateString
        } else {
            jsonFailure(json: json, key: BillboardEvent.fromDateStringJSONKey)
            return nil
        }
        
        if let fullDateWithTimeIntervalString = json[BillboardEvent.fullDateWithTimeIntervalStringJSONKey].string {
            self.fullDateWithTimeIntervalString = fullDateWithTimeIntervalString
        } else {
            jsonFailure(json: json, key: BillboardEvent.fullDateWithTimeIntervalStringJSONKey)
            return nil
        }
        
        if let hasAgenda = json[BillboardEvent.hasAgendaJSONKey].bool {
            self.hasAgenda = hasAgenda
        } else {
            jsonFailure(json: json, key: BillboardEvent.hasAgendaJSONKey)
            return nil
        }
        
        if let hasEducators = json[BillboardEvent.hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else {
            jsonFailure(json: json, key: BillboardEvent.hasEducatorsJSONKey)
            return nil
        }
        
        if let hasTheSameTimeAsPreviousItem = json[BillboardEvent.hasTheSameTimeAsPreviousItemJSONKey].bool {
            self.hasTheSameTimeAsPreviousItem = hasTheSameTimeAsPreviousItem
        } else {
            jsonFailure(json: json, key: BillboardEvent.hasTheSameTimeAsPreviousItemJSONKey)
            return nil
        }
        
        if let id = json[BillboardEvent.idJSONKey].int {
            self.id = id
        } else {
            jsonFailure(json: json, key: BillboardEvent.idJSONKey)
            return nil
        }
        
        if let isCancelled = json[BillboardEvent.isCancelledJSONKey].bool {
            self.isCancelled = isCancelled
        } else {
            jsonFailure(json: json, key: BillboardEvent.isCancelledJSONKey)
            return nil
        }
        
        if let isEmpty = json[BillboardEvent.isEmptyJSONKey].bool {
            self.isEmpty = isEmpty
        } else {
            jsonFailure(json: json, key: BillboardEvent.isEmptyJSONKey)
            return nil
        }
        
        if let isRecurrence = json[BillboardEvent.isRecurrenceJSONKey].bool {
            self.isRecurrence = isRecurrence
        } else {
            jsonFailure(json: json, key: BillboardEvent.isRecurrenceJSONKey)
            return nil
        }
        
        if let isShowImmediateHidden = json[BillboardEvent.isShowImmediateHiddenJSONKey].bool {
            self.isShowImmediateHidden = isShowImmediateHidden
        } else {
            jsonFailure(json: json, key: BillboardEvent.isShowImmediateHiddenJSONKey)
            return nil
        }
        
        if let isStudy = json[BillboardEvent.isStudyJSONKey].bool {
            self.isStudy = isStudy
        } else {
            jsonFailure(json: json, key: BillboardEvent.isStudyJSONKey)
            return nil
        }
        
        if let location = Location(from: json[BillboardEvent.locationJSONKey]) {
            self.location = location
        } else {
            jsonFailure(json: json, key: BillboardEvent.locationJSONKey)
            return nil
        }
        
        if let locationsDisplayText = json[BillboardEvent.locationsDisplayTextJSONKey].string {
            self.locationsDisplayText = locationsDisplayText
        } else {
            jsonFailure(json: json, key: BillboardEvent.locationsDisplayTextJSONKey)
            return nil
        }
        
        if let orderIndex = json[BillboardEvent.orderIndexJSONKey].int {
            self.orderIndex = orderIndex
        } else {
            jsonFailure(json: json, key: BillboardEvent.orderIndexJSONKey)
            return nil
        }
        
        if let showImmediate = json[BillboardEvent.showImmediateJSONKey].bool {
            self.showImmediate = showImmediate
        } else {
            jsonFailure(json: json, key: BillboardEvent.showImmediateJSONKey)
            return nil
        }
        
        if let showYear = json[BillboardEvent.showYearJSONKey].bool {
            self.showYear = showYear
        } else {
            jsonFailure(json: json, key: BillboardEvent.showYearJSONKey)
            return nil
        }
        
        if let startString = json[BillboardEvent.startJSONKey].string,
            let start = dateFormatter.date(from: startString) {
            self.start = start
        } else {
            jsonFailure(json: json, key: BillboardEvent.startJSONKey)
            return nil
        }
        
        if let subject = json[BillboardEvent.subjectJSONKey].string {
            self.subject = subject
        } else {
            jsonFailure(json: json, key: BillboardEvent.subjectJSONKey)
            return nil
        }
        
        if let subkindDisplayName = json[BillboardEvent.subkindDisplayNameJSONKey].string {
            self.subkindDisplayName = subkindDisplayName
        } else {
            jsonFailure(json: json, key: BillboardEvent.subkindDisplayNameJSONKey)
            return nil
        }
        
        if let timeIntervalString = json[BillboardEvent.timeIntervalStringJSONKey].string {
            self.timeIntervalString = timeIntervalString
        } else {
            jsonFailure(json: json, key: BillboardEvent.timeIntervalStringJSONKey)
            return nil
        }
        
        if let viewKind = json[BillboardEvent.viewKindJSONKey].int {
            self.viewKind = viewKind
        } else {
            jsonFailure(json: json, key: BillboardEvent.viewKindJSONKey)
            return nil
        }
        
        if let withinTheSameDay = json[BillboardEvent.withinTheSameDayJSONKey].bool {
            self.withinTheSameDay = withinTheSameDay
        } else {
            jsonFailure(json: json, key: BillboardEvent.withinTheSameDayJSONKey)
            return nil
        }
        
        if let year = json[BillboardEvent.yearJSONKey].int {
            self.year = year
        } else {
            jsonFailure(json: json, key: BillboardEvent.yearJSONKey)
            return nil
        }
    }
}

extension BillboardEvent: Equatable {
    
    public static func ==(lhs: BillboardEvent, rhs: BillboardEvent) -> Bool {
        return
            lhs.allDay                              == rhs.allDay                           &&
            lhs.contingentUnitsDisplayText          == rhs.contingentUnitsDisplayText       &&
            lhs.dateWithTimeIntervalString          == rhs.dateWithTimeIntervalString       &&
            lhs.displayDateAndTimeIntervalString    == rhs.displayDateAndTimeIntervalString &&
            lhs.divisionAlias                       == rhs.divisionAlias                    &&
            lhs.educatorsDisplayText                == rhs.educatorsDisplayText             &&
            lhs.end                                 == rhs.end                              &&
            lhs.fromDate                            == rhs.fromDate                         &&
            lhs.fromDateString                      == rhs.fromDateString                   &&
            lhs.fullDateWithTimeIntervalString      == rhs.fullDateWithTimeIntervalString   &&
            lhs.hasAgenda                           == rhs.hasAgenda                        &&
            lhs.hasEducators                        == rhs.hasEducators                     &&
            lhs.hasTheSameTimeAsPreviousItem        == rhs.hasTheSameTimeAsPreviousItem     &&
            lhs.id                                  == rhs.id                               &&
            lhs.isCancelled                         == rhs.isCancelled                      &&
            lhs.isEmpty                             == rhs.isEmpty                          &&
            lhs.isRecurrence                        == rhs.isRecurrence                     &&
            lhs.isShowImmediateHidden               == rhs.isShowImmediateHidden            &&
            lhs.isStudy                             == rhs.isStudy                          &&
            lhs.location                            == rhs.location                         &&
            lhs.locationsDisplayText                == rhs.locationsDisplayText             &&
            lhs.orderIndex                          == rhs.orderIndex                       &&
            lhs.showImmediate                       == rhs.showImmediate                    &&
            lhs.showYear                            == rhs.showYear                         &&
            lhs.start                               == rhs.start                            &&
            lhs.subject                             == rhs.subject                          &&
            lhs.subkindDisplayName                  == rhs.subkindDisplayName               &&
            lhs.timeIntervalString                  == rhs.timeIntervalString               &&
            lhs.viewKind                            == rhs.viewKind                         &&
            lhs.withinTheSameDay                    == rhs.withinTheSameDay                 &&
            lhs.year                                == rhs.year

    }
}
