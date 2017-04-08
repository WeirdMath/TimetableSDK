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

    /// The extracurricular events available for this division. Initially is `nil`. Use
    /// the fetchExtracurricularEvents(using:dispatchQueue:forceReload:completion:) method in order
    /// to get extracurricular events.
    public var extracurricularEvents: Extracurricular?

    internal var extracurricularEventsAPIQuery: String {
        return "\(alias)/events"
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
    
    /// Fetches the study levels available for the division and saves the into the `studyLevels` property.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - forceReload:    If `true`, executes the query even if if the `studyLevels` property is not `nil`.
    ///                     Othewise returns the contents of the `studyLevels` property (if it's not `nil`).
    ///                     Default is `true`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchStudyLevels(using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 forceReload: Bool = true,
                                 completion: @escaping (Result<[StudyLevel]>) -> Void) {

        if !forceReload, let studyLevels = studyLevels {
            completion(.success(studyLevels))
            return
        }
        
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
    
    /// Fetches the study levels available for the division and saves the into the `studyLevels` property.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - forceReload:    If `true`, executes the query even if if the `studyLevels` property is not `nil`.
    ///                     Othewise returns the contents of the `studyLevels` property (if it's not `nil`).
    ///                     Default is `true`.
    /// - Returns: A promise.
    public func fetchStudyLevels(using jsonData: Data? = nil, forceReload: Bool = true) -> Promise<[StudyLevel]> {
        
        return makePromise({ fetchStudyLevels(using: jsonData, forceReload: forceReload, completion: $0) })
    }

    /// Fetches the extracurricular events available for the division and saves them the into
    /// the `extracurricularEvents` property.
    ///
    /// - Parameters:
    ///   - jsonData:      If this is not `nil`, then instead of networking uses provided json data as mock
    ///                    data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue: If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                    execute a completion handler on. Otherwise uses the specified queue.
    ///                    If `jsonData` is not `nil`, setting this
    ///                    makes no change as in this case fetching happens syncronously in the current queue.
    ///                    Default value is `nil`.
    ///   - forceReload:   If `true`, executes the query even if if the `extracurricularEvents` property
    ///                    is not `nil`. Othewise returns the contents of the `extracurricularEvents`
    ///                    property (if it's not `nil`).
    ///                    Default is `true`.
    ///   - completion:    A closure that is called after a responce is received.
    public func fetchExtracurricularEvents(using jsonData: Data? = nil,
                                           dispatchQueue: DispatchQueue? = nil,
                                           forceReload: Bool = true,
                                           completion: @escaping (Result<Extracurricular>) -> Void) {

        if !forceReload, let extracurricularEvents = extracurricularEvents {
            completion(.success(extracurricularEvents))
            return
        }

        fetch(using: jsonData,
              apiQuery: extracurricularEventsAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Extracurricular>) in

                if case .success(let events) = result {
                    self?.extracurricularEvents = events
                }

                completion(result)
        }
    }

    /// Fetches the extracurricular events available for the division and saves them the into
    /// the `extracurricularEvents` property.
    ///
    /// - Parameters:
    ///   - jsonData:    If this is not `nil`, then instead of networking uses provided json data as mock
    ///                  data. May be useful for testing locally. Default value is `nil`.
    ///   - forceReload: If `true`, executes the query even if if the `extracurricularEvents` property
    ///                  is not `nil`. Othewise returns the contents of the `extracurricularEvents`
    ///                  property (if it's not `nil`).
    ///                  Default is `true`.
    /// - Returns:       A promise.
    public func fetchExtracurricularEvents(using jsonData: Data? = nil,
                                           forceReload: Bool = true) -> Promise<Extracurricular> {
        return makePromise({ fetchExtracurricularEvents(using: jsonData,
                                                        forceReload: forceReload,
                                                        completion: $0) })
    }

    /// Fetches the extracurricular events available for the division from the provided `data`.
    ///
    /// - Parameters:
    ///   - date:          The day of the week to fetch events for.
    ///   - jsonData:      If this is not `nil`, then instead of networking uses provided json data as mock
    ///                    data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue: If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                    execute a completion handler on. Otherwise uses the specified queue.
    ///                    If `jsonData` is not `nil`, setting this
    ///                    makes no change as in this case fetching happens syncronously in the current queue.
    ///                    Default value is `nil`.
    ///   - completion:    A closure that is called after a responce is received.
    public func fetchExtracurricularEvents(from date: Date,
                                           using jsonData: Data? = nil,
                                           dispatchQueue: DispatchQueue? = nil,
                                           completion: @escaping (Result<Extracurricular>) -> Void) {

        let dateString = Extracurricular.dateFormatter.string(from: date)

        fetch(using: jsonData,
              apiQuery: extracurricularEventsAPIQuery,
              parameters: ["fromDate" : dateString],
              dispatchQueue: dispatchQueue,
              timetable: timetable,
              completion: completion)
    }

    /// Fetches the extracurricular events available for the division from the provided `data`.
    ///
    /// - Parameters:
    ///   - date:          The day of the week to fetch events for.
    ///   - jsonData:      If this is not `nil`, then instead of networking uses provided json data as mock
    ///                    data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:         A promise.
    public func fetchExtracurricularEvents(from date: Date,
                                           using jsonData: Data? = nil) -> Promise<Extracurricular> {

        return makePromise({ fetchExtracurricularEvents(from: date, using: jsonData, completion: $0) })
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
