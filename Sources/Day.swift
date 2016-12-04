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

/// The information about a day with `Event`s in it.
public final class Day : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    public let date: Date
    public let name: String
    public let events: [Event]
    
    internal init(date: Date, name: String, events: [Event]) {
        self.date   = date
        self.name   = name
        self.events = events
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            date    = try map(json["Day"], transformation: Day.dateFormatter.date(from:))
            name    = try map(json["DayString"])
            
            // In different parts of the API days are serialized similarly, but have different json keys.
            do {
                events = try map(json["DayStudyEvents"])
            } catch {
                events = try map(json["DayEvents"])
            }
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Day.self)
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
