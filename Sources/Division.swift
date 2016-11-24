//
//  Division.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public final class Division {
    
    public let name: String
    fileprivate static let _nameJSONKey = "Name"
    
    public let alias: String
    fileprivate static let _aliasJSONKey = "Alias"
    
    public let oid: String
    fileprivate static let _oidJSONKey = "Oid"
    
    public fileprivate(set) var studyLevels: [StudyLevel]?
    
    internal init(name: String, alias: String, oid: String) {
        self.name = name
        self.alias = alias
        self.oid = oid
    }
}

extension Division: _APIQueryable {
    
    internal var _apiQuery: String {
        return "\(alias)/studyprograms"
    }
    
    internal func _saveFetchResult(_ json: JSON) throws {
        
        if let studyLevels = json.array?.flatMap(StudyLevel.init), !studyLevels.isEmpty {
            self.studyLevels = studyLevels
        } else {
            throw TimetableError.incorrectJSONFormat(json)
        }
    }
}

extension Division: JSONRepresentable {
    
    convenience init?(from json: JSON) {
        
        guard let name = json[Division._nameJSONKey].string else {
            _jsonFailure(json: json, key: Division._nameJSONKey)
            return nil
        }
        
        guard let alias = json[Division._aliasJSONKey].string else {
            _jsonFailure(json: json, key: Division._aliasJSONKey)
            return nil
        }
        
        guard let oid = json[Division._oidJSONKey].string else {
            _jsonFailure(json: json, key: Division._oidJSONKey)
            return nil
        }
        
        self.init(name: name, alias: alias, oid: oid)
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
