//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

/// The information about a student group formed in an `AdmissionYear`.
public final class StudentGroup {
    
    public let id: Int
    fileprivate static let idJSONKey = "StudentGroupId"
    
    public let name: String
    fileprivate static let nameJSONKey = "StudentGroupName"
    
    public let studyForm: String
    fileprivate static let studyFormJSONKey = "StudentGroupStudyForm"
    
    public let profiles: String
    fileprivate static let profilesJSONKey = "StudentGroupProfiles"
    
    public let divisionAlias: String
    fileprivate static let divisionAliasJSONKey = "PublicDivisionAlias"
    
    /// The current week schedule for this student group. Initially is `nil`. Use
    /// the `fetchCurrentWeek(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get the current week.
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

extension StudentGroup: APIQueryable {
    
    /// Returnes an API method for fetching this entity.
    internal var apiQuery: String {
        return "\(divisionAlias)/studentgroup/\(id)/events"
    }
    
    /// Converts an API response to an appropriate form.
    ///
    /// - Parameter json: An API response as JSON.
    /// - Throws: A `TimetableError` that is caught in the `fetch(using:dispatchQueue:baseURL:completion)` method
    ///           and retunred in a completion handler of thet method.
    internal func saveFetchResult(_ json: JSON) throws {
        
        if let currentWeek = Week(from: json) {
            self.currentWeek = currentWeek
        } else {
            throw TimetableError.incorrectJSONFormat(json)            
        }
    }
}

extension StudentGroup: JSONRepresentable {
    
    internal convenience init?(from json: JSON) {
        
        guard let id = json[StudentGroup.idJSONKey].int else {
            jsonFailure(json: json, key: StudentGroup.idJSONKey)
            return nil
        }
        
        guard let name = json[StudentGroup.nameJSONKey].string else {
            jsonFailure(json: json, key: StudentGroup.nameJSONKey)
            return nil
        }
        
        guard let studyForm = json[StudentGroup.studyFormJSONKey].string else {
            jsonFailure(json: json, key: StudentGroup.studyFormJSONKey)
            return nil
        }
        
        guard let profiles = json[StudentGroup.profilesJSONKey].string else {
            jsonFailure(json: json, key: StudentGroup.profilesJSONKey)
            return nil
        }
        
        guard let divisionAlias = json[StudentGroup.divisionAliasJSONKey].string  else {
            jsonFailure(json: json, key: StudentGroup.divisionAliasJSONKey)
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
