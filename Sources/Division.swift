//
//  Division.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

/// The information about a division of the Univeristy.
public final class Division : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let name: String
    
    public let alias: String
    
    public let oid: String
    
    /// The study levels available for this division. Initially is `nil`. Use
    /// the `fetchStudyLevels(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get study levels.
    public internal(set) var studyLevels: [StudyLevel]?
    internal var studyLevelsAPIQuery: String {
        return "\(alias)/studyprograms"
    }
    
    internal init(name: String, alias: String, oid: String) {
        self.name  = name
        self.alias = alias
        self.oid   = oid
    }
    
    public init(from json: JSON) throws {
        name    = try map(json["Name"])
        alias   = try map(json["Alias"])
        oid     = try map(json["Oid"])
    }
}

extension Division: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Division, rhs: Division) -> Bool {
        
        return
            lhs.name    == rhs.name     &&
            lhs.alias   == rhs.alias    &&
            lhs.oid     == rhs.oid
    }
}

extension Division: CustomStringConvertible {}
