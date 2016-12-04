//
//  Educator.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 04.12.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

public final class Educator : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let displayName: String
    public let employments: [Employment]
    public let fullName: String
    public let id: Int
    
    internal init(displayName: String, employments: [Employment], fullName: String, id: Int) {
        self.displayName = displayName
        self.employments = employments
        self.fullName = fullName
        self.id = id
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            displayName = try map(json["DisplayName"])
            employments = try map(json["Employments"])
            fullName    = try map(json["FullName"])
            id          = try map(json["Id"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Educator.self)
        }
    }
}

extension Educator : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Educator, rhs: Educator) -> Bool{
        return
            lhs.displayName == rhs.displayName &&
            lhs.employments == rhs.employments &&
            lhs.fullName    == rhs.fullName    &&
            lhs.id          == rhs.id
    }
}

extension Educator : CustomStringConvertible {}
