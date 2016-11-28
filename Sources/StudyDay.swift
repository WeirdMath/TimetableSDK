//
//  StudyDay.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// The information about a day in a `Week`.
public struct StudyDay {
    
    fileprivate static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    public let date: Date
    fileprivate static let dateJSONKey = "Day"
    
    public let name: String
    fileprivate static let nameJSONKey = "DayString"
    
    public let events: [StudyEvent]
    fileprivate static let eventsJSONKey = "DayStudyEvents"
}

extension StudyDay: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StudyDay.dateFormat
        
        if let dateString = json[StudyDay.dateJSONKey].string,
            let date = dateFormatter.date(from: dateString) {
            
            self.date = date
        } else {
            jsonFailure(json: json, key: StudyDay.dateJSONKey)
            return nil
        }
        
        if let name = json[StudyDay.nameJSONKey].string {
            self.name = name
        } else {
            jsonFailure(json: json, key: StudyDay.nameJSONKey)
            return nil
        }
        
        if let events = json[StudyDay.eventsJSONKey].array?.flatMap(StudyEvent.init) {
            self.events = events
        } else {
            jsonFailure(json: json, key: StudyDay.eventsJSONKey)
            return nil
        }
    }
}

extension StudyDay: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: StudyDay, rhs: StudyDay) -> Bool{
        
        return
            lhs.date    == rhs.date     &&
            lhs.name    == rhs.name     &&
            lhs.events  == rhs.events
    }
}

extension StudyDay: CustomStringConvertible {}
