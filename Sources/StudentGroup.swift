//
//  StudentGroup.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
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
    ///   - completion:     A closure that is called after a responce is received. In case of success, its
    ///                     parameter is `nil`, otherwise — an error.
    public func fetchCurrentWeek(using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 completion: @escaping (TimetableError?) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: currentWeekAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Week>) in
                
                switch result {
                case .success(let value):
                    self?.currentWeek = value
                    completion(nil)
                case .failure(let error):
                    completion(error as? TimetableError)
                }
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
