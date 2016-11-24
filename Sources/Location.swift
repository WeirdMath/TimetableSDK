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

public struct Location {
    
    public let educatorsDisplayText: String
    fileprivate static let _educatorsDisplayTextJSONKey = "EducatorsDisplayText"
    
    public let hasEducators: Bool
    fileprivate static let _hasEducatorsJSONKey = "HasEducators"
    
    public let educatorIDs: [(Int, String)]
    fileprivate static let _educatorIDsJSONKey = "EducatorIds"
    
    public let isEmpty: Bool
    fileprivate static let _isEmptyJSONKey = "IsEmpty"
    
    public let displayName: String
    fileprivate static let _displayNameJSONKey = "DisplayName"
    
    public let hasGeographicCoordinates: Bool
    fileprivate static let _hasGeographicCoordinatesJSONKey = "HasGeographicCoordinates"
    
    public let latitude: Double?
    fileprivate static let _latitudeJSONKey = "Latitude"
    
    public let longitude: Double?
    fileprivate static let _longitudeJSONKey = "Longitude"
    
    public let latitudeValue: String?
    fileprivate static let _latitudeValueJSONKey = "LatitudeValue"
    
    public let longitudeValue: String?
    fileprivate static let _longitudeValueJSONKey = "LongitudeValue"
}

extension Location: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let educatorsDisplayText = json[Location._educatorsDisplayTextJSONKey].string {
            self.educatorsDisplayText = educatorsDisplayText
        } else {
            _jsonFailure(json: json, key: Location._educatorsDisplayTextJSONKey)
            return nil
        }
        
        if let hasEducators = json[Location._hasEducatorsJSONKey].bool {
            self.hasEducators = hasEducators
        } else {
            _jsonFailure(json: json, key: Location._hasEducatorsJSONKey)
            return nil
        }
        
        if let educatorIDs = json[Location._educatorIDsJSONKey]
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
        } else {
            _jsonFailure(json: json, key: Location._educatorIDsJSONKey)
            return nil
        }
        
        if let isEmpty = json[Location._isEmptyJSONKey].bool {
            self.isEmpty = isEmpty
        } else {
            _jsonFailure(json: json, key: Location._isEmptyJSONKey)
            return nil
        }
        
        if let displayName = json[Location._displayNameJSONKey].string {
            self.displayName = displayName
        } else {
            _jsonFailure(json: json, key: Location._displayNameJSONKey)
            return nil
        }
        
        if let hasGeographicCoordinates = json[Location._hasGeographicCoordinatesJSONKey].bool {
            self.hasGeographicCoordinates = hasGeographicCoordinates
        } else {
            _jsonFailure(json: json, key: Location._hasGeographicCoordinatesJSONKey)
            return nil
        }
        
        if hasGeographicCoordinates {
            
            if let latitude = json[Location._latitudeJSONKey].double {
                self.latitude = latitude
            } else {
                _jsonFailure(json: json, key: Location._latitudeJSONKey)
                return nil
            }
            
            if let longitude = json[Location._longitudeJSONKey].double {
                self.longitude = longitude
            } else {
                _jsonFailure(json: json, key: Location._longitudeJSONKey)
                return nil
            }
            
            if let latitudeValue = json[Location._latitudeValueJSONKey].string {
                self.latitudeValue = latitudeValue
            } else {
                _jsonFailure(json: json, key: Location._latitudeValueJSONKey)
                return nil
            }
            
            if let longitudeValue = json[Location._longitudeValueJSONKey].string {
                self.longitudeValue = longitudeValue
            } else {
                _jsonFailure(json: json, key: Location._longitudeValueJSONKey)
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
        
        return lhs.educatorsDisplayText     == rhs.educatorsDisplayText                 &&
            lhs.hasEducators                == rhs.hasEducators                         &&
            zip(lhs.educatorIDs, rhs.educatorIDs).reduce(true, { $0 && $1.0 == $1.1 })  &&
            lhs.isEmpty                     == rhs.isEmpty                              &&
            lhs.displayName                 == rhs.displayName                          &&
            lhs.hasGeographicCoordinates    == rhs.hasGeographicCoordinates             &&
            lhs.latitude                    == rhs.latitude                             &&
            lhs.longitude                   == rhs.longitude                            &&
            lhs.latitudeValue               == rhs.latitudeValue                        &&
            lhs.longitudeValue              == rhs.longitudeValue
    }
}

extension Location: CustomStringConvertible {}
