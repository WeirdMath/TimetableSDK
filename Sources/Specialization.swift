//
//  Specialization.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public struct Specialization {
    
    public let name: String
    fileprivate static let _nameJSONKey = "Name"
    
    public var admissionYears: [AdmissionYear]
    fileprivate static let _admissionYearsJSONKey = "AdmissionYears"
}

extension Specialization: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let name = json[Specialization._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: Specialization._nameJSONKey)
            return nil
        }
        
        if let admissionYears = json[Specialization._admissionYearsJSONKey].array?.flatMap(AdmissionYear.init) {
            self.admissionYears = admissionYears
        } else {
            _jsonFailure(json: json, key: Specialization._admissionYearsJSONKey)
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
