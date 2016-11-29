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
public final class Division : JSONRepresentable {
    
    public let name: String
    
    public let alias: String
    
    public let oid: String
    
    /// The study levels available for this division. Initially is `nil`. Use
    /// the `fetchStudyLevels(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get study levels.
    public fileprivate(set) var studyLevels: [StudyLevel]?
    internal static let studyLevelsResourceIdentifier = "studyLevels"
    
    internal init(name: String, alias: String, oid: String) {
        self.name = name
        self.alias = alias
        self.oid = oid
    }
    
    internal init(from json: JSON) throws {
        name    = try map(json["Name"])
        alias   = try map(json["Alias"])
        oid     = try map(json["Oid"])
    }
}

extension Division: APIQueryable {
    
    internal var studyLevelsAPIQuery: String {
        return "\(alias)/studyprograms"
    }
    
    /// Converts an API response to an appropriate form.
    ///
    /// - Parameter json: An API response as JSON.
    /// - Throws: A `TimetableError` that is caught in the `fetch(using:dispatchQueue:baseURL:completion)` method
    ///           and retunred in a completion handler of thet method.
    internal func saveFetchResult(_ json: JSON, resourceIdentifier: String) throws {
        
        switch resourceIdentifier {
        case Division.studyLevelsResourceIdentifier:
            let _studyLevels: [StudyLevel] = try map(json)
            studyLevels = _studyLevels
            return
        default:
            assertionFailure("This should never happen.")
        }
        
        throw TimetableError.incorrectJSONFormat(json, description: "")
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
