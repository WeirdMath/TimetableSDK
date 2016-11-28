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
public struct Location {
    
    public let educatorsDisplayText: String?
    fileprivate static let educatorsDisplayTextJSONKey = "EducatorsDisplayText"
    
    public let hasEducators: Bool
    fileprivate static let hasEducatorsJSONKey = "HasEducators"
    
    public let educatorIDs: [(Int, String)]?
    fileprivate static let educatorIDsJSONKey = "EducatorIds"
    
    public let isEmpty: Bool
    fileprivate static let isEmptyJSONKey = "IsEmpty"
    
    public let displayName: String
    fileprivate static let displayNameJSONKey = "DisplayName"
    
    public let hasGeographicCoordinates: Bool
    fileprivate static let hasGeographicCoordinatesJSONKey = "HasGeographicCoordinates"
    
    public let latitude: Double?
    fileprivate static let latitudeJSONKey = "Latitude"
    
    public let longitude: Double?
    fileprivate static let longitudeJSONKey = "Longitude"
    
    public let latitudeValue: String?
    fileprivate static let latitudeValueJSONKey = "LatitudeValue"
    
    public let longitudeValue: String?
    fileprivate static let longitudeValueJSONKey = "LongitudeValue"
}

extension Location: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let educatorsDisplayText = json[Location.educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else if !json[Location.educatorsDisplayTextJSONKey].exists() {
            self.educatorsDisplayText = nil
        } else {
            jsonFailure(json: json, key: Location.educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let hasEducators = json[Location.hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else if !json[Location.hasEducatorsJSONKey].exists() {
            self.hasEducators = false
        } else {
            jsonFailure(json: json, key: Location.hasEducatorsJSONKey)
            return nil
        }
        
        if let educatorIDs = json[Location.educatorIDsJSONKey]
            .array?
            .flatMap({ (tuple: JSON) -> (Int, String)? in
                if let id = tuple["Item1"].int,
                    let name = tuple["Item2"].string {
                    return (id, name)
                } else {
                    return nil
                }
            }) {
            self.educatorIDs = educatorIDs
        } else if !json[Location.educatorIDsJSONKey].exists() {
            self.educatorIDs = nil
        } else {
            jsonFailure(json: json, key: Location.educatorIDsJSONKey)
            return nil
        }
        
        if let isEmpty = json[Location.isEmptyJSONKey].bool {
            self.isEmpty = isEmpty
        } else {
            jsonFailure(json: json, key: Location.isEmptyJSONKey)
            return nil
        }
        
        if let displayName = json[Location.displayNameJSONKey].string {
            self.displayName = displayName
        } else {
            jsonFailure(json: json, key: Location.displayNameJSONKey)
            return nil
        }
        
        if let hasGeographicCoordinates = json[Location.hasGeographicCoordinatesJSONKey].bool {
            self.hasGeographicCoordinates = hasGeographicCoordinates
        } else {
            jsonFailure(json: json, key: Location.hasGeographicCoordinatesJSONKey)
            return nil
        }
        
        if hasGeographicCoordinates {
            
            if let latitude = json[Location.latitudeJSONKey].double {
                self.latitude = latitude
            } else {
                jsonFailure(json: json, key: Location.latitudeJSONKey)
                return nil
            }
            
            if let longitude = json[Location.longitudeJSONKey].double {
                self.longitude = longitude
            } else {
                jsonFailure(json: json, key: Location.longitudeJSONKey)
                return nil
            }
            
            if let latitudeValue = json[Location.latitudeValueJSONKey].string {
                self.latitudeValue = latitudeValue
            } else {
                jsonFailure(json: json, key: Location.latitudeValueJSONKey)
                return nil
            }
            
            if let longitudeValue = json[Location.longitudeValueJSONKey].string {
                self.longitudeValue = longitudeValue
            } else {
                jsonFailure(json: json, key: Location.longitudeValueJSONKey)
                return nil
            }
            
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
