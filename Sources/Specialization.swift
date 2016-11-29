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
public struct Specialization : JSONRepresentable {
    
    public let name: String
    
    public var admissionYears: [AdmissionYear]
}

extension Specialization {
    
    internal init(from json: JSON) throws {
        name            = try map(json["Name"])
        admissionYears  = try map(json["AdmissionYears"])
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
