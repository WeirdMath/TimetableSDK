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
public struct Specialization {
    
    public let name: String
    fileprivate static let nameJSONKey = "Name"
    
    public var admissionYears: [AdmissionYear]
    fileprivate static let admissionYearsJSONKey = "AdmissionYears"
}

extension Specialization: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let name = json[Specialization.nameJSONKey].string {
            self.name = name
        } else {
            jsonFailure(json: json, key: Specialization.nameJSONKey)
            return nil
        }
        
        if let admissionYears = json[Specialization.admissionYearsJSONKey].array?.flatMap(AdmissionYear.init) {
            self.admissionYears = admissionYears
        } else {
            jsonFailure(json: json, key: Specialization.admissionYearsJSONKey)
            return nil
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
