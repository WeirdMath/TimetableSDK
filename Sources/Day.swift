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

public struct Day {
    
    fileprivate static let _dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public var date: Date
    fileprivate static let _dateJSONKey = "Day"
    
    public var name: String
    fileprivate static let _nameJSONKey = "DayString"
    
    public var events: [Event]
    fileprivate static let _eventsJSONKey = "DayStudyEvents"
}

extension Day: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Day._dateFormat
        
        if let dateString = json[Day._dateJSONKey].string,
            let date = dateFormatter.date(from: dateString) {
            
            self.date = date
        } else {
            _jsonFailure(json: json, key: Day._dateJSONKey)
            return nil
        }
        
        if let name = json[Day._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: Day._nameJSONKey)
            return nil
        }
        
        if let events = json[Day._eventsJSONKey].array?.flatMap(Event.init) {
            self.events = events
        } else {
            _jsonFailure(json: json, key: Day._eventsJSONKey)
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
