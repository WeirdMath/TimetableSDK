//
//  BillboardDay.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 28.11.2016.
//
//

import Foundation
import SwiftyJSON

public final class BillboardDay : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    public let day: Date
    public let events: [BillboardEvent]
    public let dayString: String
    
    internal init(day: Date,
                  events: [BillboardEvent],
                  dayString: String) {
        self.day       = day
        self.events    = events
        self.dayString = dayString
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            day         = try map(json["Day"], transformation: BillboardDay.dateFormatter.date(from:))
            events      = try map(json["DayEvents"])
            dayString   = try map(json["DayString"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: BillboardDay.self)
        }
    }
}

extension BillboardDay: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: BillboardDay, rhs: BillboardDay) -> Bool {
        return
            lhs.day         == rhs.day       &&
            lhs.events      == rhs.events    &&
            lhs.dayString   == rhs.dayString
    }
}
