//
//  Day.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// The information about a day in a `Week`.
public struct Day {
    
    fileprivate static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public let date: Date
    fileprivate static let dateJSONKey = "Day"
    
    public let name: String
    fileprivate static let nameJSONKey = "DayString"
    
    public let events: [StudyEvent]
    fileprivate static let eventsJSONKey = "DayStudyEvents"
}

extension Day: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Day.dateFormat
        
        if let dateString = json[Day.dateJSONKey].string,
            let date = dateFormatter.date(from: dateString) {
            
            self.date = date
        } else {
            jsonFailure(json: json, key: Day.dateJSONKey)
            return nil
        }
        
        if let name = json[Day.nameJSONKey].string {
            self.name = name
        } else {
            jsonFailure(json: json, key: Day.nameJSONKey)
            return nil
        }
        
        if let events = json[Day.eventsJSONKey].array?.flatMap(StudyEvent.init) {
            self.events = events
        } else {
            jsonFailure(json: json, key: Day.eventsJSONKey)
            return nil
        }
    }
}

extension Day: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Day, rhs: Day) -> Bool{
        
        return
            lhs.date    == rhs.date     &&
            lhs.name    == rhs.name     &&
            lhs.events  == rhs.events
    }
}

extension Day: CustomStringConvertible {}
