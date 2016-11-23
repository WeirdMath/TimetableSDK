//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public struct StudentGroup {
    
    public var id: Int
    fileprivate static let _idJSONKey = "StudentGroupId"
    
    public var name: String
    fileprivate static let _nameJSONKey = "StudentGroupName"
    
    public var studyForm: String
    fileprivate static let _studyFormJSONKey = "StudentGroupStudyForm"
    
    public var profiles: String
    fileprivate static let _profilesJSONKey = "StudentGroupProfiles"
    
    public var divisionAlias: String
    fileprivate static let _divisionAliasJSONKey = "PublicDivisionAlias"
}

extension StudentGroup: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let id = json[StudentGroup._idJSONKey].int {
            self.id = id
        } else {
            _jsonFailure(json: json, key: StudentGroup._idJSONKey)
            return nil
        }
        
        if let name = json[StudentGroup._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: StudentGroup._nameJSONKey)
            return nil
        }
        
        if let studyForm = json[StudentGroup._studyFormJSONKey].string {
            self.studyForm = studyForm
        } else {
            _jsonFailure(json: json, key: StudentGroup._studyFormJSONKey)
            return nil
        }
        
        if let profiles = json[StudentGroup._profilesJSONKey].string {
            self.profiles = profiles
        } else {
            _jsonFailure(json: json, key: StudentGroup._profilesJSONKey)
            return nil
        }
        
        if let divisionAlias = json[StudentGroup._divisionAliasJSONKey].string {
            self.divisionAlias = divisionAlias
        } else {
            _jsonFailure(json: json, key: StudentGroup._divisionAliasJSONKey)
            return nil
        }
    }
}

extension StudentGroup: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: StudentGroup, rhs: StudentGroup) -> Bool {
        
        return
            lhs.id              == rhs.id               &&
            lhs.name            == rhs.name             &&
            lhs.studyForm       == rhs.studyForm        &&
            lhs.profiles        == rhs.profiles         &&
            lhs.divisionAlias   == rhs.divisionAlias
    }
}

extension StudentGroup: CustomStringConvertible {}
