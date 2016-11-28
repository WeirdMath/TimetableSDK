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
public final class AdmissionYear {
    
    public let isEmpty: Bool
    fileprivate static let isEmptyJSONKey = "IsEmpty"
    
    public let divisionAlias: String
    fileprivate static let divisionAliasJSONKey = "PublicDivisionAlias"
    
    public let studyProgramID: Int
    fileprivate static let studyProgramIDJSONKey = "StudyProgramId"
    
    public let name: String
    fileprivate static let nameJSONKey = "YearName"
    
    public let number: Int
    fileprivate static let numberJSONKey = "YearNumber"
    
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
            if let studentGroups = json.array?.flatMap(StudentGroup.init), !studentGroups.isEmpty {
                self.studentGroups = studentGroups
                return
            }
        default:
            assertionFailure("This should never happen.")
        }

        throw TimetableError.incorrectJSONFormat(json)
    }
}

extension AdmissionYear: JSONRepresentable {
    
    internal convenience init?(from json: JSON) {
        
        guard let isEmpty = json[AdmissionYear.isEmptyJSONKey].bool else {
            jsonFailure(json: json, key: AdmissionYear.isEmptyJSONKey)
            return nil
        }
        
        guard let divisionAlias = json[AdmissionYear.divisionAliasJSONKey].string else {
            jsonFailure(json: json, key: AdmissionYear.divisionAliasJSONKey)
            return nil
        }
        
        guard let studyProgramID = json[AdmissionYear.studyProgramIDJSONKey].int else {
            jsonFailure(json: json, key: AdmissionYear.studyProgramIDJSONKey)
            return nil
        }
        
        guard let name = json[AdmissionYear.nameJSONKey].string else {
            jsonFailure(json: json, key: AdmissionYear.nameJSONKey)
            return nil
        }
        
        guard let number = json[AdmissionYear.numberJSONKey].int else {
            jsonFailure(json: json, key: AdmissionYear.numberJSONKey)
            return nil
        }
        
        self.init(isEmpty: isEmpty,
                  divisionAlias: divisionAlias,
                  studyProgramID: studyProgramID,
                  name: name,
                  number: number)
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
