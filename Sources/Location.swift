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
public struct Location : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
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
    
    internal init(educatorsDisplayText: String?,
                  hasEducators: Bool,
                  educatorIDs: [(Int, String)]?,
                  isEmpty: Bool,
                  displayName: String,
                  hasGeographicCoordinates: Bool,
                  latitude: Double?,
                  longitude: Double?,
                  latitudeValue: String?,
                  longitudeValue: String?) {
        self.educatorsDisplayText     = educatorsDisplayText
        self.hasEducators             = hasEducators
        self.educatorIDs              = educatorIDs
        self.isEmpty                  = isEmpty
        self.displayName              = displayName
        self.hasGeographicCoordinates = hasGeographicCoordinates
        self.latitude                 = latitude
        self.longitude                = longitude
        self.latitudeValue            = latitudeValue
        self.longitudeValue           = longitudeValue
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
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
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Location.self)
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
        
        return
            lhs.educatorsDisplayText        == rhs.educatorsDisplayText                     &&
            lhs.hasEducators                == rhs.hasEducators                             &&
            lhs.educatorIDs                 == rhs.educatorIDs                              &&
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
