//
//  Location.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible
import Foundation

/// The information about a location that an `Event` may take place in.
public struct Location : JSONRepresentable {
    
    public let educatorsDisplayText: String?
    
    public let hasEducators: Bool
    
    public let educatorIDs: [(Int, String)]?
    
    public let isEmpty: Bool
    
    public let displayName: String
    
    public let hasGeographicCoordinates: Bool
    
    public let latitude: Double?
    
    public let longitude: Double?
    
    public let latitudeValue: String?
    
    public let longitudeValue: String?
}

extension Location {
    
    internal init(from json: JSON) throws {
        educatorsDisplayText        = try map(json["EducatorsDisplayText"])
        hasEducators                = (try? map(json["HasEducators"])) ?? false
        educatorIDs                 = try map(json["EducatorIds"])
        isEmpty                     = try map(json["IsEmpty"])
        displayName                 = try map(json["DisplayName"])
        hasGeographicCoordinates    = try map(json["HasGeographicCoordinates"])
        
        if hasGeographicCoordinates {
            latitude                = try map(json["Latitude"])
            longitude               = try map(json["Longitude"])
            latitudeValue           = try map(json["LatitudeValue"])
            longitudeValue          = try map(json["LongitudeValue"])
            
        } else {
            latitude = nil
            longitude = nil
            latitudeValue = nil
            longitudeValue = nil
        }
    }
}

extension Location: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        
        return lhs.educatorsDisplayText     == rhs.educatorsDisplayText                     &&
            lhs.hasEducators                == rhs.hasEducators                             &&
            lhs.educatorIDs == nil && rhs.educatorIDs == nil ||
            (lhs.educatorIDs != nil && rhs.educatorIDs != nil &&
            zip(lhs.educatorIDs!, rhs.educatorIDs!).reduce(true, { $0 && $1.0 == $1.1 }))   &&
            lhs.isEmpty                     == rhs.isEmpty                                  &&
            lhs.displayName                 == rhs.displayName                              &&
            lhs.hasGeographicCoordinates    == rhs.hasGeographicCoordinates                 &&
            lhs.latitude                    == rhs.latitude                                 &&
            lhs.longitude                   == rhs.longitude                                &&
            lhs.latitudeValue               == rhs.latitudeValue                            &&
            lhs.longitudeValue              == rhs.longitudeValue
    }
}

extension Location: CustomStringConvertible {}
