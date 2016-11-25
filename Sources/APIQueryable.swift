//
//  _APIQueryable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import Foundation
import Alamofire
import SwiftyJSON

/// For each conforming type this protocol provides the `fetch(using:dispatchQueue:baseURL:completion)`
/// method for free. A type must implement the `apiQuery` property that returnes an API method, and
/// the saveFetchResult(_:) method that converts an API response to an appropriate form.
internal protocol APIQueryable: class {
    
    /// Returnes an API method for fetching this entity.
    var apiQuery: String { get }
    
    /// Converts an API response to an appropriate form.
    ///
    /// - Parameter json: An API response as JSON.
    /// - Throws: A `TimetableError` that is caught in the `fetch(using:dispatchQueue:baseURL:completion)` method
    ///           and retunred in a completion handler of thet method.
    func saveFetchResult(_ json: JSON) throws
}

internal extension APIQueryable {
    
    /// Does all the networking things.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for testing locally.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a networking request on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - baseURL:        The URL to use `apiQuery` on.
    ///   - completion:     A closure that is called after a responce is received. In case of success, its
    ///                     parameter is `nil`, otherwise — an error.
    internal func fetch(using jsonData: Data?,
                         dispatchQueue: DispatchQueue?,
                         baseURL: URL,
                         completion: ((TimetableError?) -> Void)?) {
        
        if let jsonData = jsonData {
            do {
                try saveFetchResult(JSON(data: jsonData))
            } catch {
                completion?((error as! TimetableError))
                return
            }
            
            completion?(nil)
        } else {
            Alamofire
                .request(baseURL.appendingPathComponent(apiQuery))
                .validate(statusCode: 200 ..< 300)
                .validate(contentType: ["application/json"])
                .responseData(queue: dispatchQueue) { [weak self] response in
                    
                    switch response.result {
                        
                    case .success(let data):
                        do {
                            try self?.saveFetchResult(JSON(data: data))
                        } catch {
                            completion?((error as! TimetableError))
                            return
                        }
                        
                        completion?(nil)
                        
                    case .failure(let error):
                        completion?(TimetableError.networkingError(error))
                    }
            }
        }
    }
}
