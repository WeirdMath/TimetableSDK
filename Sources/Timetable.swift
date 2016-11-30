//
//  Timetable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import SwiftyJSON
import enum Alamofire.Result

/// A pivit point for fetching data from the Timetable service.
public final class Timetable {
    
    /// The default url used to send API requests against.
    public static let defaultBaseURL = URL(string: "http://timetable.spbu.ru/api/v1/")!
    
    /// The url used to send API requests against.
    public let baseURL: URL
    
    /// Creates a new instance with provided `basURL`.
    ///
    /// - Parameter baseURL: The url used to send API requests against.
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    /// Creates a new instance with base url set to `Timetable.defaultBaseURL`.
    public init() {
        baseURL = Timetable.defaultBaseURL
    }
    
    /// The divisions of the University. Initially is `nil`. Use
    /// the `fetchDivisions(using:dispatchQueue:completion:)` methods in order to get divisions.
    public fileprivate(set) var divisions: [Division]?
    
    internal var divisionsAPIQuery: String {
        return "divisions"
    }
    
    /// The billboard. Initially is `nil`. Use
    /// the `fetchBillboard(using:dispatchQueue:completion:)` methods in order to get divisions.
    public fileprivate(set) var billboard: Billboard?
    
    internal var billboardAPIQuery: String {
        return "Billboard/events"
    }
    
    /// Fetches the divisions of the University. In case of success saves the divisions into the
    /// `divisions` property.
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
    public func fetchDivisions(using jsonData: Data? = nil,
                               dispatchQueue: DispatchQueue? = nil,
                               completion: @escaping (TimetableError?) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: divisionsAPIQuery,
              dispatchQueue: dispatchQueue,
              baseURL: baseURL) { [weak self] (result: Result<[Division]>) in
                
                switch result {
                case .success(let value):
                    self?.divisions = value
                    completion(nil)
                case .failure(let error):
                    completion(error as? TimetableError)
                }
        }
    }
    
    
    /// Fetches the study levels available for the provided `division`.
    ///
    /// - Parameters:
    ///   - division:       The division to fetch study levels for.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a networking request on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received. In case of success, its
    ///                     parameter is `nil`, otherwise — an error.
    public func fetchStudyLevels(for division: Division,
                                 using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 completion: @escaping (TimetableError?) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: division.studyLevelsAPIQuery,
              dispatchQueue: dispatchQueue,
              baseURL: baseURL) { [weak division] (result: Result<[StudyLevel]>) in
                
                switch result {
                case .success(let value):
                    division?.studyLevels = value
                    completion(nil)
                case .failure(let error):
                    completion(error as? TimetableError)
                }
        }
    }
    
    /// Fetches the sudent groups formed in the provided `admissionYear`.
    ///
    /// - Parameters:
    ///   - admissionYear:  The admission year to fetch student groups for.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a networking request on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received. In case of success, its
    ///                     parameter is `nil`, otherwise — an error.
    public func fetchStudentGroups(for admissionYear: AdmissionYear,
                                   using jsonData: Data? = nil,
                                   dispatchQueue: DispatchQueue? = nil,
                                   completion: @escaping (TimetableError?) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: admissionYear.studentGroupsAPIQuery,
              dispatchQueue: dispatchQueue,
              baseURL: baseURL) { [weak admissionYear] (result: Result<[StudentGroup]>) in
                
                switch result {
                case .success(let value):
                    admissionYear?.studentGroups = value
                    completion(nil)
                case .failure(let error):
                    completion(error as? TimetableError)
                }
        }
    }
    
    /// Fetches the current week schedule for the provided `studentGroup`.
    ///
    /// - Parameters:
    ///   - studentGroup:   The student group to fetch the current week for.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a networking request on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received. In case of success, its
    ///                     parameter is `nil`, otherwise — an error.
    public func fetchCurrentWeek(for studentGroup: StudentGroup,
                                 using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 completion: @escaping (TimetableError?) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: studentGroup.currentWeekAPIQuery,
              dispatchQueue: dispatchQueue,
              baseURL: baseURL) { [weak studentGroup] (result: Result<Week>) in
                
                switch result {
                case .success(let value):
                    studentGroup?.currentWeek = value
                    completion(nil)
                case .failure(let error):
                    completion(error as? TimetableError)
                }
        }
    }
}
