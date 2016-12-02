//
//  Division.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import PromiseKit
import enum Alamofire.Result
import DefaultStringConvertible

/// The information about a division of the Univeristy.
public final class Division : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    public let name: String
    
    public let alias: String
    
    public let oid: String
    
    /// The study levels available for this division. Initially is `nil`. Use
    /// the `fetchStudyLevels(for:using:dispatchQueue:completion:)` method of a `Timetable` instance
    /// in order to get study levels.
    public var studyLevels: [StudyLevel]?
    internal var studyLevelsAPIQuery: String {
        return "\(alias)/studyprograms"
    }
    
    internal init(name: String, alias: String, oid: String) {
        self.name  = name
        self.alias = alias
        self.oid   = oid
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            name    = try map(json["Name"])
            alias   = try map(json["Alias"])
            oid     = try map(json["Oid"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Division.self)
        }
    }
    
    /// Fetches the study levels available for the division.
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
    public func fetchStudyLevels(using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 completion: @escaping (Result<[StudyLevel]>) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: studyLevelsAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<[StudyLevel]>) in
                
                if case .success(let value) = result {
                    self?.studyLevels = value
                }
                
                completion(result)
        }
    }
    
    /// Fetches the study levels available for the division.
    ///
    /// - Parameter jsonData: If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    /// - Returns: A promise.
    public func fetchStudyLevels(using jsonData: Data? = nil) -> Promise<[StudyLevel]> {
        
        return makePromise({ fetchStudyLevels(using: jsonData, completion: $0) })
    }
}

extension Division: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Division, rhs: Division) -> Bool {
        
        return
            lhs.name    == rhs.name     &&
            lhs.alias   == rhs.alias    &&
            lhs.oid     == rhs.oid
    }
}

extension Division: CustomStringConvertible {}
