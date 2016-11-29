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
public final class AdmissionYear : JSONRepresentable {
    
    public let isEmpty: Bool
    
    public let divisionAlias: String
    
    public let studyProgramID: Int
    
    public let name: String
    
    public let number: Int
    
    /// The sudent groups formed in this year. Initially is `nil`. Use
    /// the `fetchStudentGroups(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get student groups.
    public fileprivate(set) var studentGroups: [StudentGroup]?
    internal static let studentGroupsResourceIdentifier = "studentGroups"
    
    internal init(isEmpty: Bool,
                  divisionAlias: String,
                  studyProgramID: Int,
                  name: String,
                  number: Int) {
        
        self.isEmpty = isEmpty
        self.divisionAlias = divisionAlias
        self.studyProgramID = studyProgramID
        self.name = name
        self.number = number
    }
    
    internal init(from json: JSON) throws {
        isEmpty         = try map(json["IsEmpty"])
        divisionAlias   = try map(json["PublicDivisionAlias"])
        studyProgramID  = try map(json["StudyProgramId"])
        name            = try map(json["YearName"])
        number          = try map(json["YearNumber"])
    }
}

extension AdmissionYear: APIQueryable {
    
    internal var studentGroupsAPIQuery: String {
        return "\(divisionAlias)/studyprogram/\(studyProgramID)/studentgroups"
    }
    
    /// Converts an API response to an appropriate form.
    ///
    /// - Parameter json: An API response as JSON.
    /// - Throws: A `TimetableError` that is caught in the `fetch(using:dispatchQueue:baseURL:completion)` method
    ///           and retunred in a completion handler of thet method.
    internal func saveFetchResult(_ json: JSON, resourceIdentifier: String) throws {
        
        switch resourceIdentifier {
        case AdmissionYear.studentGroupsResourceIdentifier:
            let _studentGroups: [StudentGroup] = try map(json)
            studentGroups = _studentGroups
            return
        default:
            assertionFailure("This should never happen.")
        }

        throw TimetableError.incorrectJSONFormat(json, description: "")
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
