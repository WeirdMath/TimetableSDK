//
//  EventGrouping.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 04.12.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

public final class EventGrouping: JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            events.forEach { $0.timetable = timetable }
        }
    }
    
    public let caption: String
    public let events: [Event]
    
    internal init(caption: String, events: [Event]) {
        self.caption = caption
        self.events = events
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            caption = try map(json["Caption"])
            events  = try map(json["Events"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: EventGrouping.self)
        }
    }
}

extension EventGrouping : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: EventGrouping, rhs: EventGrouping) -> Bool{
        return
            lhs.caption == rhs.caption &&
            lhs.events  == rhs.events
    }
}

extension EventGrouping : CustomStringConvertible {}
