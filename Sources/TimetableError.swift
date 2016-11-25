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
    case incorrectJSONFormat(JSON)
    
    /// Returned when a networking error occures.
    case networkingError(Error)
}
