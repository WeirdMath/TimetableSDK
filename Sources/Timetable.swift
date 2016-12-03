//
//  Timetable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import SwiftyJSON
import PromiseKit
import enum Alamofire.Result

/// A pivot point for fetching data from the Timetable service.
public final class Timetable {
    
    /// The default url used to send API requests against.
    public static let defaultBaseURL = URL(string: "http://timetable.spbu.ru/api/v1/")!
    
    /// The url used to send API requests against.
    public var baseURL: URL
    
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
    public var divisions: [Division]?
    
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
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchDivisions(using jsonData: Data? = nil,
                               dispatchQueue: DispatchQueue? = nil,
                               completion: @escaping (Result<[Division]>) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: divisionsAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: self) { [weak self] (result: Result<[Division]>) in
                
                if case .success(let value) = result {
                    self?.divisions = value
                }
                
                completion(result)
        }
    }
    
    /// Fetches the divisions of the University. In case of success saves the divisions into the
    /// `divisions` property.
    ///
    /// - Parameter jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                         data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:              A promise.
    public func fetchDivisions(using jsonData: Data? = nil) -> Promise<[Division]> {
        return makePromise({ fetchDivisions(using: jsonData, completion: $0) })
    }
    
    /// Fetches the billboard. In case of success saves the billboard into the
    /// `billboard` property.
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
    public func fetchBillboard(using jsonData: Data? = nil,
                               dispatchQueue: DispatchQueue? = nil,
                               completion: @escaping (Result<Billboard>) -> Void) {
        
        fetch(using: jsonData,
              apiQuery: billboardAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: self) { [weak self] (result: Result<Billboard>) in
                
                if case .success(let value) = result {
                    self?.billboard = value
                }
                
                completion(result)
        }
    }
    
    /// Fetches the billboard. In case of success saves the billboard into the
    /// `billboard` property.
    ///
    /// - Parameter jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                         data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:              A promise.
    public func fetchBillboard(using jsonData: Data? = nil) -> Promise<Billboard> {
        return makePromise({ fetchBillboard(using: jsonData, completion: $0) })
    }
    
    /// Fetches the billboard with events listed from provided `date`.
    ///
    /// - Parameters:
    ///   - date:           The day of the week to fetch a billboard for.
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchBillboard(from date: Date,
                        using jsonData: Data? = nil,
                        dispatchQueue: DispatchQueue? = nil,
                        completion: @escaping (Result<Billboard>) -> Void) {
        
        let dateString = Billboard.dateFormatter.string(from: date)
        
        fetch(using: jsonData,
              apiQuery: billboardAPIQuery,
              parameters: ["fromDate" : dateString],
              dispatchQueue: dispatchQueue,
              timetable: self,
              completion: completion)
    }
    
    /// Fetches the billboard with events listed from provided `date`.
    ///
    /// - Parameters:
    ///   - date:       The day of the week to fetch a billboard for.
    ///   - jsonData:   If this is not `nil`, then instead of networking uses provided json data as mock
    ///                 data. May be useful for testing locally. Default value is `nil`.
    /// - Returns:      A promise.
    public func fetchBillboard(from date: Date, using jsonData: Data? = nil) -> Promise<Billboard> {
        return makePromise({ fetchBillboard(from: date, using: jsonData, completion: $0) })
    }
}
