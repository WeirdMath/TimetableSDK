//
//  BillboardEvent.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON

public struct BillboardEvent : JSONRepresentable {
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    public let allDay: Bool
    
    public let contingentUnitsDisplayText: String
    
    public let dateWithTimeIntervalString: String
    
    public let displayDateAndTimeIntervalString: String
    
    public let divisionAlias: String
    
    public let educatorsDisplayText: String
    
    public let end: Date
    
    public let fromDate: Date
    
    public let fromDateString: String
    
    public let fullDateWithTimeIntervalString: String
    
    public let hasAgenda: Bool
    
    public let hasEducators: Bool
    
    public let hasTheSameTimeAsPreviousItem: Bool
    
    public let id: Int
    
    public let isCancelled: Bool
    
    public let isEmpty: Bool
    
    public let isRecurrence: Bool
    
    public let isShowImmediateHidden: Bool
    
    public let isStudy: Bool
    
    public let location: Location
    
    public let locationsDisplayText: String
    
    public let orderIndex: Int

    public let showImmediate: Bool
    
    public let showYear: Bool
    
    public let start: Date
    
    public let subject: String
    
    public let subkindDisplayName: String
    
    public let timeIntervalString: String
    
    public let viewKind: Int
    
    public let withinTheSameDay: Bool
    
    public let year: Int
    fileprivate static let yearJSONKey = "Year"
}

extension BillboardEvent {
    
    init(from json: JSON) throws {
        allDay                              = try map(json["AllDay"])
        contingentUnitsDisplayText          = try map(json["ContingentUnitsDisplayTest"])
        dateWithTimeIntervalString          = try map(json["DateWithTimeIntervalString"])
        displayDateAndTimeIntervalString    = try map(json["DisplayDateAndTimeIntervalString"])
        divisionAlias                       = try map(json["DivisionAlias"])
        educatorsDisplayText                = try map(json["EducatorsDisplayText"])
        end                                 = try map(json["End"],
                                                      transformation: BillboardEvent.dateFormatter.date(from:))
        fromDate                            = try map(json["FromDate"],
                                                      transformation: BillboardEvent.dateFormatter.date(from:))
        fromDateString                      = try map(json["FromDateString"])
        fullDateWithTimeIntervalString      = try map(json["FullDateWithTimeIntervalString"])
        hasAgenda                           = try map(json["HasAgenda"])
        hasEducators                        = try map(json["HasEducators"])
        hasTheSameTimeAsPreviousItem        = try map(json["HasTheSameTimeAsPreviousItem"])
        id                                  = try map(json["Id"])
        isCancelled                         = try map(json["IsCancelled"])
        isEmpty                             = try map(json["IsEmpty"])
        isRecurrence                        = try map(json["IsRecurrence"])
        isShowImmediateHidden               = try map(json["IsShowImmediateHidden"])
        isStudy                             = try map(json["IsStudy"])
        location                            = try map(json["Location"])
        locationsDisplayText                = try map(json["LocationsDisplayText"])
        orderIndex                          = try map(json["OrderIndex"])
        showImmediate                       = try map(json["ShowImmediate"])
        showYear                            = try map(json["ShowYear"])
        start                               = try map(json["Start"],
                                                      transformation: BillboardEvent.dateFormatter.date(from:))
        subject                             = try map(json["Subject"])
        subkindDisplayName                  = try map(json["SubkindDisplayName"])
        timeIntervalString                  = try map(json["TimeIntervalString"])
        viewKind                            = try map(json["ViewKind"])
        withinTheSameDay                    = try map(json["WithinTheSameDay"])
        year                                = try map(json["Year"])
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
