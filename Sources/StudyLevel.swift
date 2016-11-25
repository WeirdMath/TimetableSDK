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
public struct StudyLevel {
    
    public let name: String
    fileprivate static let nameJSONKey = "StudyLevelName"
    
    public var specializations: [Specialization]
    fileprivate static let specializationsJSONKey = "StudyProgramCombinations"
    
    public let hasCourse6: Bool
    fileprivate static let hasCourse6JSONKey = "HasCourse6"
}

extension StudyLevel: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let name = json[StudyLevel.nameJSONKey].string {
            self.name = name
        } else {
            jsonFailure(json: json, key: StudyLevel.nameJSONKey)
            return nil
        }
        
        if let specializations = json[StudyLevel.specializationsJSONKey].array?.flatMap(Specialization.init) {
            self.specializations = specializations
        } else {
            jsonFailure(json: json, key: StudyLevel.specializationsJSONKey)
            return nil
        }
        
        if let hasCourse6 = json[StudyLevel.hasCourse6JSONKey].bool {
            self.hasCourse6 = hasCourse6
        } else {
            jsonFailure(json: json, key: StudyLevel.hasCourse6JSONKey)
            return nil
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
