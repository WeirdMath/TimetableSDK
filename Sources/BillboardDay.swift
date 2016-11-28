//
//  BillboardDay.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON

public struct BillboardDay {
    
    fileprivate static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public let day: Date
    fileprivate static let dayJSONKey = "Day"
    
    public let events: [BillboardEvent]
    fileprivate static let eventsJSONKey = "DayEvents"
    
    public let dayString: String
    fileprivate static let dayStringJSONKey = "DayString"
}

extension BillboardDay: JSONRepresentable {
    
    init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = BillboardDay.dateFormat
        
        if let dayString = json[BillboardDay.dayJSONKey].string,
            let day = dateFormatter.date(from: dayString) {
            self.day = day
        } else {
            jsonFailure(json: json, key: BillboardDay.dayJSONKey)
            return nil
        }
        
        if let dayEvents = json[BillboardDay.eventsJSONKey].array?.flatMap(BillboardEvent.init) {
            self.events = dayEvents
        } else {
            jsonFailure(json: json, key: BillboardDay.eventsJSONKey)
            return nil
        }
        
        if let dayString = json[BillboardDay.dayStringJSONKey].string {
            self.dayString = dayString
        } else {
            jsonFailure(json: json, key: BillboardDay.dayStringJSONKey)
            return nil
        }

    }
}

extension BillboardDay: Equatable {
    
    public static func ==(lhs: BillboardDay, rhs: BillboardDay) -> Bool {
        return
            lhs.day         == rhs.day       &&
            lhs.events      == rhs.events    &&
            lhs.dayString   == rhs.dayString
    }
}
