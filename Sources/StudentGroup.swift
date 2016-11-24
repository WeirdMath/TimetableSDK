//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public final class StudentGroup {
    
    public let id: Int
    fileprivate static let _idJSONKey = "StudentGroupId"
    
    public let name: String
    fileprivate static let _nameJSONKey = "StudentGroupName"
    
    public let studyForm: String
    fileprivate static let _studyFormJSONKey = "StudentGroupStudyForm"
    
    public let profiles: String
    fileprivate static let _profilesJSONKey = "StudentGroupProfiles"
    
    public let divisionAlias: String
    fileprivate static let _divisionAliasJSONKey = "PublicDivisionAlias"
    
    public fileprivate(set) var currentWeek: Week?
    
    internal init(id: Int,
                  name: String,
                  studyForm: String,
                  profiles: String,
                  divisionAlias: String) {
        self.id = id
        self.name = name
        self.studyForm = studyForm
        self.profiles = profiles
        self.divisionAlias = divisionAlias
    }
}

extension StudentGroup: _APIQueryable {
    
    var _apiQuery: String {
        return "\(divisionAlias)/studentgroup/\(id)/events"
    }
    
    func _saveFetchResult(_ json: JSON) throws {
        
        if let currentWeek = Week(from: json) {
            self.currentWeek = currentWeek
        } else {
            throw TimetableError.incorrectJSONFormat
        }
    }
}

extension StudentGroup: JSONRepresentable {
    
    internal convenience init?(from json: JSON) {
        
        guard let id = json[StudentGroup._idJSONKey].int else {
            _jsonFailure(json: json, key: StudentGroup._idJSONKey)
            return nil
        }
        
        guard let name = json[StudentGroup._nameJSONKey].string else {
            _jsonFailure(json: json, key: StudentGroup._nameJSONKey)
            return nil
        }
        
        guard let studyForm = json[StudentGroup._studyFormJSONKey].string else {
            _jsonFailure(json: json, key: StudentGroup._studyFormJSONKey)
            return nil
        }
        
        guard let profiles = json[StudentGroup._profilesJSONKey].string else {
            _jsonFailure(json: json, key: StudentGroup._profilesJSONKey)
            return nil
        }
        
        guard let divisionAlias = json[StudentGroup._divisionAliasJSONKey].string  else {
            _jsonFailure(json: json, key: StudentGroup._divisionAliasJSONKey)
            return nil
        }
        
        self.init(id: id,
                  name: name,
                  studyForm: studyForm,
                  profiles: profiles,
                  divisionAlias: divisionAlias)
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
