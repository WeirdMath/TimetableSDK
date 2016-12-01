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
public final class StudentGroup : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
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
    public internal(set) var currentWeek: Week?
    internal var currentWeekAPIQuery: String {
        return "\(divisionAlias)/studentgroup/\(id)/events"
    }
    
    internal init(id: Int,
                  name: String,
                  studyForm: String,
                  profiles: String,
                  divisionAlias: String) {
        self.id            = id
        self.name          = name
        self.studyForm     = studyForm
        self.profiles      = profiles
        self.divisionAlias = divisionAlias
    }
    
    public init(from json: JSON) throws {
        id              = try map(json["StudentGroupId"])
        name            = try map(json["StudentGroupName"])
        studyForm       = try map(json["StudentGroupStudyForm"])
        profiles        = try map(json["StudentGroupProfiles"])
        divisionAlias   = try map(json["PublicDivisionAlias"])
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
