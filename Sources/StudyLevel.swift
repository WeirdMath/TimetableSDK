//
//  StudyLevel.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public struct StudyLevel {
    
    public var name: String
    fileprivate static let _nameJSONKey = "StudyLevelName"
    
    public var specializations: [Specialization]
    fileprivate static let _specializationsJSONKey = "StudyProgramCombinations"
    
    public var hasCourse6: Bool
    fileprivate static let _hasCourse6JSONKey = "HasCourse6"
}

extension StudyLevel: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let name = json[StudyLevel._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: StudyLevel._nameJSONKey)
            return nil
        }
        
        if let specializations = json[StudyLevel._specializationsJSONKey].array?.flatMap(Specialization.init) {
            self.specializations = specializations
        } else {
            _jsonFailure(json: json, key: StudyLevel._specializationsJSONKey)
            return nil
        }
        
        if let hasCourse6 = json[StudyLevel._hasCourse6JSONKey].bool {
            self.hasCourse6 = hasCourse6
        } else {
            _jsonFailure(json: json, key: StudyLevel._hasCourse6JSONKey)
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
