//
//  Specialization.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

/// The infromation about a specialization available for a `StudyLevel`.
public final class Specialization : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            admissionYears.forEach { $0.timetable = timetable }
        }
    }
    
    public let name: String
    public var admissionYears: [AdmissionYear]
    
    internal init(name: String, admissionYears: [AdmissionYear]) {
        self.name           = name
        self.admissionYears = admissionYears
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            name            = try map(json["Name"])
            admissionYears  = try map(json["AdmissionYears"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Specialization.self)
        }
    }
}

extension Specialization: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Specialization, rhs: Specialization) -> Bool {
        return
            lhs.name            == rhs.name             &&
            lhs.admissionYears  == rhs.admissionYears
    }
}

extension Specialization: CustomStringConvertible {}
