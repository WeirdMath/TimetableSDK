//
//  Educator.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 04.12.2016.
//
//

import Foundation
import SwiftyJSON
import PromiseKit

public final class Educator : JSONRepresentable, TimetableEntity {
    
    internal static func educatorScheduleAPIQuery(id: Int) -> String {
        return "educator/\(id)/events"
    }
    
    fileprivate var educatorScheduleAPIQuery: String {
        return Educator.educatorScheduleAPIQuery(id: id)
    }
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            employments.forEach { $0.timetable = timetable }
        }
    }
    
    public let displayName: String
    public let employments: [Employment]
    public let fullName: String
    public let id: Int
    
    internal init(displayName: String, employments: [Employment], fullName: String, id: Int) {
        self.displayName = displayName
        self.employments = employments
        self.fullName = fullName
        self.id = id
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            displayName = try map(json["DisplayName"])
            employments = try map(json["Employments"])
            fullName    = try map(json["FullName"])
            id          = try map(json["Id"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Educator.self)
        }
    }
    
    /// Fetches the educator's schedule.
    ///
    /// - Parameters:
    ///   - forNextTerm:    If `false`, fetches the schedule for the current term, otherwise — for the next term.
    ///                     Default is `false`.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronouslyx
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchSchedule(forNextTerm: Bool = false,
                              using jsonData: Data? = nil,
                              dispatchQueue: DispatchQueue? = nil,
                              completion: @escaping (Result<EducatorSchedule>) -> Void) {
        
        let next = forNextTerm ? 1 : 0
        
        fetch(using: jsonData,
              apiQuery: educatorScheduleAPIQuery,
              parameters: ["next" : next],
              dispatchQueue: dispatchQueue,
              timetable: timetable,
              completion: completion)
    }
    
    /// Fetches the educator's schedule.
    ///
    /// - Parameters:
    ///   - forNextTerm:    If `false`, fetches the schedule for the current term, otherwise — for the next term.
    ///                     Default is `false`.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:          A promise.
    public func fetchSchedule(forNextTerm: Bool = false,
                              using jsonData: Data? = nil) -> Promise<EducatorSchedule> {
        
        return makePromise({ fetchSchedule(forNextTerm: forNextTerm, using: jsonData, completion: $0) })
    }
}

extension Educator : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Educator, rhs: Educator) -> Bool{
        return
                lhs.displayName == rhs.displayName &&
                lhs.employments == rhs.employments &&
                lhs.fullName    == rhs.fullName    &&
                lhs.id          == rhs.id
    }
}
