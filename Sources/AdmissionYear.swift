//
//  AdmissionYear.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import enum Alamofire.Result
import SwiftyJSON
import DefaultStringConvertible
import PromiseKit

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
    /// the `fetchStudentGroups(for:using:dispatchQueue:completion:)` method in order to get student groups.
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
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            isEmpty         = try map(json["IsEmpty"])
            divisionAlias   = try map(json["PublicDivisionAlias"])
            studyProgramID  = try map(json["StudyProgramId"])
            name            = try map(json["YearName"])
            number          = try map(json["YearNumber"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: AdmissionYear.self)
        }
    }
    
    /// Fetches the sudent groups formed in the admission year.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchStudentGroups(using jsonData: Data? = nil,
                                   dispatchQueue: DispatchQueue? = nil,
                                   completion: @escaping (Result<[StudentGroup]>) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: studentGroupsAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<[StudentGroup]>) in
                
                if case .success(let value) = result {
                    self?.studentGroups = value
                }
                
                completion(result)
        }
    }
    
    /// Fetches the sudent groups formed in the admission year.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:          A promise.
    public func fetchStudentGroups(using jsonData: Data? = nil) -> Promise<[StudentGroup]> {
        return makePromise({ fetchStudentGroups(using: jsonData, completion: $0) })
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
