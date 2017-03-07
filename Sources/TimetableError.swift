//
//  TimetableError.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import SwiftyJSON

/// Represents an error that can occure while querying the Timetable service.
public enum TimetableError: Error {
    
    /// Returned when couldn't parse a JSON responce returned from Timetable or loaded from a `*.json` file.
    case incorrectJSONFormat(JSON, description: String)
    
    /// Returned when a networking error occures.
    case networkingError(Error)
    
    /// Returned when a `Timetable` object is deallocated prior to fetching.
    case timetableIsDeallocated
    
    /// Returned when attempting to fetch a next or previous week with the current week's
    /// `studentGroup` property not set.
    case unknownStudentGroup

    /// Returned when attempting to fetch a corresponding room for `Location`, but no room was found.
    case couldntFindRoomForLocation
    
    private static func incorrectJSONDescription<T>(for type: T.Type) -> String {
        return "Could not convert JSON to \(type)"
    }
    
    internal static func incorrectJSON<T>(_ json: JSON, whenConverting type: T.Type) -> TimetableError {
        return TimetableError.incorrectJSONFormat(json, description: incorrectJSONDescription(for: type))
    }
}

extension TimetableError: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: TimetableError, rhs: TimetableError) -> Bool {
        
        switch (lhs, rhs) {
        case (incorrectJSONFormat(let json1, let description1), incorrectJSONFormat(let json2, let description2)):
            return json1 == json2 && description1 == description2
        case (.networkingError, .networkingError):
            return true
        case (.timetableIsDeallocated, .timetableIsDeallocated):
            return true
        default:
            return false
        }
    }
}
