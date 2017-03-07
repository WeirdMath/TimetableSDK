//
//  Employment.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 04.12.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible
import Foundation

/// The information about an educator's employment.
public final class Employment : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let department: String
    public let position: String
    
    internal init(department: String, position: String) {
        self.department = department
        self.position = position
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            department = try map(json["Department"])
            position = try map(json["Position"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Employment.self)
        }
    }
}

extension Employment : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Employment, rhs: Employment) -> Bool {
        return
            lhs.department == rhs.department &&
            rhs.position   == rhs.position
    }
}

extension Employment : CustomStringConvertible {}
