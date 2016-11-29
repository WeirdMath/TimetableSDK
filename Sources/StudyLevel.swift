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
public struct StudyLevel : JSONRepresentable {
    
    public let name: String
    
    public var specializations: [Specialization]
    
    public let hasCourse6: Bool
}

extension StudyLevel {
    
    internal init(from json: JSON) throws {
        name            = try map(json["StudyLevelName"])
        specializations = try map(json["StudyProgramCombinations"])
        hasCourse6      = try map(json["HasCourse6"])
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
