//
//  Division.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public struct Division {
    
    public var name: String
    fileprivate static let _nameJSONKey = "Name"
    
    public var alias: String
    fileprivate static let _aliasJSONKey = "Alias"
    
    public var oid: String
    fileprivate static let _oidJSONKey = "Oid"
}

extension Division: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let name = json[Division._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: Division._nameJSONKey)
            return nil
        }
        
        if let alias = json[Division._aliasJSONKey].string {
            self.alias = alias
        } else {
            _jsonFailure(json: json, key: Division._aliasJSONKey)
            return nil
        }
        
        if let oid = json[Division._oidJSONKey].string {
            self.oid = oid
        } else {
            _jsonFailure(json: json, key: Division._oidJSONKey)
            return nil
        }
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
