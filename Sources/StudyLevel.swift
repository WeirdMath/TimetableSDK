//
//  StudyLevel.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// The information about a study level available in a `Division`.
public final class StudyLevel : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            specializations.forEach { $0.timetable = timetable }
        }
    }
    
    public let name: String
    public var specializations: [Specialization]
    public let hasCourse6: Bool
    
    internal init(name: String, specializations: [Specialization], hasCourse6: Bool) {
        self.name            = name
        self.specializations = specializations
        self.hasCourse6      = hasCourse6
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            name            = try map(json["StudyLevelName"])
            specializations = try map(json["StudyProgramCombinations"])
            hasCourse6      = try map(json["HasCourse6"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: StudyLevel.self)
        }
    }
}

extension StudyLevel: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: StudyLevel, rhs: StudyLevel) -> Bool {
        
        return
            lhs.name            == rhs.name             &&
            lhs.hasCourse6      == rhs.hasCourse6       &&
            lhs.specializations == rhs.specializations
    }
}

extension StudyLevel: CustomStringConvertible {}
