//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import PromiseKit
import enum Alamofire.Result
import SwiftyJSON
import DefaultStringConvertible

/// The information about a student group formed in an `AdmissionYear`.
public final class StudentGroup : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let id: Int
    public let name: String
    public let studyForm: String
    public let profiles: String
    public let divisionAlias: String
    
    /// The current week schedule for this student group. Initially is `nil`. Use
    /// the `fetchCurrentWeek(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get the current week.
    public internal(set) var currentWeek: Week?
    internal var weekAPIQuery: String {
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
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            id              = try map(json["StudentGroupId"])
            name            = try map(json["StudentGroupName"])
            studyForm       = try map(json["StudentGroupStudyForm"])
            profiles        = try map(json["StudentGroupProfiles"])
            divisionAlias   = try map(json["PublicDivisionAlias"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: StudentGroup.self)
        }
    }
    
    /// Fetches the current week schedule for the student group.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a networking request on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchCurrentWeek(using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 completion: @escaping (Result<Week>) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: weekAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Week>) in
                
                if case .success(let value) = result {
                    value.studentGroup = self
                    self?.currentWeek = value
                }
                
                completion(result)
        }
    }
    
    /// Fetches the current week schedule for the student group.
    ///
    /// - Parameter jsonData: If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    /// - Returns: A promise.
    public func fetchCurrentWeek(using jsonData: Data? = nil) -> Promise<Week> {
        return makePromise({ fetchCurrentWeek(using: jsonData, completion: $0) })
    }
    
    /// Fetches the week that begins with the specified `day` for the student group.
    ///
    /// - Parameters:
    ///   - day             The day the week begins.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchWeek(beginningWithDay day: Date,
                          using jsonData: Data? = nil,
                          dispatchQueue: DispatchQueue? = nil,
                          completion: @escaping (Result<Week>) -> Void) {

        let dayString = Week.dateForatter.string(from: day)
        
        fetch(using: jsonData,
              apiQuery: weekAPIQuery,
              parameters: ["weekMonday" : dayString],
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Week>) in
                
                if case .success(let value) = result {
                    value.studentGroup = self
                }
                
                completion(result)
        }
    }
    
    /// Fetches the week that begins with the specified `day` for the student group.
    ///
    /// - Parameters:
    ///   - day:        The day the week begins.
    ///   - jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:      A promise.
    public func fetchWeek(beginningWithDay day: Date, using jsonData: Data? = nil) -> Promise<Week> {
        return makePromise({ fetchWeek(beginningWithDay: day, using: jsonData, completion: $0) })
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

// FIXME: https://github.com/jessesquires/DefaultStringConvertible/issues/9
// extension StudentGroup: CustomStringConvertible {}
