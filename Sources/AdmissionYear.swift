//
//  AdmissionYear.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

/// The information about an admission year for a particular `Specialization`.
public final class AdmissionYear : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let isEmpty: Bool
    public let divisionAlias: String
    public let studyProgramID: Int
    public let name: String
    public let number: Int
    
    /// The sudent groups formed in this year. Initially is `nil`. Use
    /// the `fetchStudentGroups(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get student groups.
    public internal(set) var studentGroups: [StudentGroup]?
    internal var studentGroupsAPIQuery: String {
        return "\(divisionAlias)/studyprogram/\(studyProgramID)/studentgroups"
    }
    
    internal init(isEmpty: Bool,
                  divisionAlias: String,
                  studyProgramID: Int,
                  name: String,
                  number: Int) {
        
        self.isEmpty        = isEmpty
        self.divisionAlias  = divisionAlias
        self.studyProgramID = studyProgramID
        self.name           = name
        self.number         = number
    }
    
    public init(from json: JSON) throws {
        isEmpty         = try map(json["IsEmpty"])
        divisionAlias   = try map(json["PublicDivisionAlias"])
        studyProgramID  = try map(json["StudyProgramId"])
        name            = try map(json["YearName"])
        number          = try map(json["YearNumber"])
    }
    

}

extension AdmissionYear: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: AdmissionYear, rhs: AdmissionYear) -> Bool{
        return
            lhs.isEmpty         == rhs.isEmpty          &&
            lhs.divisionAlias   == rhs.divisionAlias    &&
            lhs.studyProgramID  == rhs.studyProgramID   &&
            lhs.name            == rhs.name             &&
            lhs.number          == rhs.number
    }
}

extension AdmissionYear: CustomStringConvertible {}
