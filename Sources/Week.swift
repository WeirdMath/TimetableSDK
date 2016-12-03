//
//  Week.swift
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

/// The information about a study week for a `StudentGroup`.
public final class Week : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?
    
    /// The student group this week contains information for.
    public weak var studentGroup: StudentGroup?
    
    /// The week following `self`.
    public var next: Week?
    
    /// The week preceding `self`.
    public weak var previous: Week?
    
    internal static let dateForatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    public let previousWeekFirstDay: Date
    public let nextWeekFirstDay: Date
    public let isPreviousWeekReferenceAvailable: Bool
    public let isNextWeekReferenceAvailable: Bool
    public let isCurrentWeekReferenceAvailable: Bool
    public let weekDisplayText: String
    public let days: [Day]
    public let viewName: String
    public let firstDay: Date
    public let studentGroupID: Int
    public let studentGroupDisplayName: String
    public let timetableDisplayName: String
    
    internal init(previousWeekFirstDay: Date,
                  nextWeekFirstDay: Date,
                  isPreviousWeekReferenceAvailable: Bool,
                  isNextWeekReferenceAvailable: Bool,
                  isCurrentWeekReferenceAvailable: Bool,
                  weekDisplayText: String,
                  days: [Day],
                  viewName: String,
                  firstDay: Date,
                  studentGroupID: Int,
                  studentGroupDisplayName: String,
                  timetableDisplayName: String) {
        self.previousWeekFirstDay             = previousWeekFirstDay
        self.nextWeekFirstDay                 = nextWeekFirstDay
        self.isPreviousWeekReferenceAvailable = isPreviousWeekReferenceAvailable
        self.isNextWeekReferenceAvailable     = isNextWeekReferenceAvailable
        self.isCurrentWeekReferenceAvailable  = isCurrentWeekReferenceAvailable
        self.weekDisplayText                  = weekDisplayText
        self.days                             = days
        self.viewName                         = viewName
        self.firstDay                         = firstDay
        self.studentGroupID                   = studentGroupID
        self.studentGroupDisplayName          = studentGroupDisplayName
        self.timetableDisplayName             = timetableDisplayName
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            previousWeekFirstDay             = try map(json["PreviousWeekMonday"],
                                                       transformation: Week.dateForatter.date(from:))
            nextWeekFirstDay                 = try map(json["NextWeekMonday"],
                                                       transformation: Week.dateForatter.date(from:))
            isPreviousWeekReferenceAvailable = try map(json["IsPreviousWeekReferenceAvailable"])
            isNextWeekReferenceAvailable     = try map(json["IsNextWeekReferenceAvailable"])
            isCurrentWeekReferenceAvailable  = try map(json["IsCurrentWeekReferenceAvailable"])
            weekDisplayText                  = try map(json["WeekDisplayText"])
            days                             = try map(json["Days"])
            viewName                         = try map(json["ViewName"])
            firstDay                         = try map(json["WeekMonday"],
                                                       transformation: Week.dateForatter.date(from:))
            studentGroupID                   = try map(json["StudentGroupId"])
            studentGroupDisplayName          = try map(json["StudentGroupDisplayName"])
            timetableDisplayName             = try map(json["TimeTableDisplayName"])
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Week.self)
        }
    }
    
    /// Fetches the week that follows `self`.
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
    public func fetchNextWeek(using jsonData: Data? = nil,
                              dispatchQueue: DispatchQueue? = nil,
                              completion: @escaping (Result<Week>) -> Void) {
        
        guard let weekAPIQuery = weekAPIQuery else {
            completion(.failure(TimetableError.unknownStudentGroup))
            return
        }
        
        let dayString = Week.dateForatter.string(from: nextWeekFirstDay)
        
        fetch(using: jsonData,
              apiQuery: weekAPIQuery,
              parameters: ["weekMonday" : dayString],
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Week>) in
                
                if case .success(let value) = result {
                    self?.next = value
                    value.previous = self
                }
                
                completion(result)
        }
    }
    
    /// Fetches the week that follows `self`.
    ///
    /// - Parameter jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                         data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:              A promise.
    public func fetchNextWeek(using jsonData: Data? = nil) -> Promise<Week> {
        return makePromise({ fetchNextWeek(using: jsonData, completion: $0) })
    }
    
    /// Fetches the week that precedes `self`.
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
    public func fetchPreviousWeek(using jsonData: Data? = nil,
                                  dispatchQueue: DispatchQueue? = nil,
                                  completion: @escaping (Result<Week>) -> Void) {
        
        guard let weekAPIQuery = weekAPIQuery else {
            completion(.failure(TimetableError.unknownStudentGroup))
            return
        }
        
        let dayString = Week.dateForatter.string(from: previousWeekFirstDay)
        
        fetch(using: jsonData,
              apiQuery: weekAPIQuery,
              parameters: ["weekMonday" : dayString],
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<Week>) in
                
                if case .success(let value) = result {
                    self?.previous = value
                    value.next = self
                }
                
                completion(result)
        }
    }
    
    /// Fetches the week that precedes `self`.
    ///
    /// - Parameter jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                         data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:              A promise.
    public func fetchPreviousWeek(using jsonData: Data? = nil) -> Promise<Week> {
        return makePromise({ fetchPreviousWeek(using: jsonData, completion: $0) })
    }
    
    private var weekAPIQuery: String? {
        if let studentGroup = studentGroup {
            return "\(studentGroup.divisionAlias)/studentgroup/\(studentGroupID)/events"
        } else {
            return nil
        }
    }
}

extension Week: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Week, rhs: Week) -> Bool {
        return
            lhs.previousWeekFirstDay             == rhs.previousWeekFirstDay             &&
                lhs.nextWeekFirstDay                 == rhs.nextWeekFirstDay                 &&
                lhs.isPreviousWeekReferenceAvailable == rhs.isPreviousWeekReferenceAvailable &&
                lhs.isNextWeekReferenceAvailable     == rhs.isNextWeekReferenceAvailable     &&
                lhs.isCurrentWeekReferenceAvailable  == rhs.isCurrentWeekReferenceAvailable  &&
                lhs.weekDisplayText                  == rhs.weekDisplayText                  &&
                lhs.days                             == rhs.days                             &&
                lhs.viewName                         == rhs.viewName                         &&
                lhs.firstDay                         == rhs.firstDay                         &&
                lhs.studentGroupID                   == rhs.studentGroupID                   &&
                lhs.studentGroupDisplayName          == rhs.studentGroupDisplayName          &&
                lhs.timetableDisplayName             == rhs.timetableDisplayName
    }
}

// FIXME: https://github.com/jessesquires/DefaultStringConvertible/issues/9
// extension Week: CustomStringConvertible {}
