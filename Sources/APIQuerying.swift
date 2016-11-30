//
//  APIQuerying.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import Foundation
import Alamofire
import SwiftyJSON

private func mapToArray<T : JSONRepresentable>(_ json: JSON) throws -> [T] {
    return try map(json)
}

private func mapToValue<T : JSONRepresentable>(_ json: JSON) throws -> T {
    return try map(json)
}

private func _fetch<T>(using jsonData: Data?,
                    apiQuery: String,
                    dispatchQueue: DispatchQueue?,
                    baseURL: URL,
                    map: @escaping (JSON) throws -> T,
                    completion: @escaping (Result<T>) -> Void) {
    
    if let jsonData = jsonData {
        do {
            completion(.success(try map(JSON(data: jsonData))))
        } catch {
            completion(.failure(error))
        }
    } else {
        Alamofire
            .request(baseURL.appendingPathComponent(apiQuery))
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/json"])
            .responseData(queue: dispatchQueue) { response in
                switch response.result {
                case .success(let data):
                    do {
                        completion(.success(try map(JSON(data: data))))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(TimetableError.networkingError(error)))
                }
        }
    }
}

/// Does all the networking things.
///
/// - Parameters:
///   - jsonData:           If this is not `nil`, then instead of networking uses provided json data as mock
///                         data. May be useful for testing locally.
///   - apiQuery:           An API method to request.
///   - dispatchQueue:      If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
///                         execute a networking request on. Otherwise uses the specified queue.
///                         If `jsonData` is not `nil`, setting this
///                         makes no change as in this case fetching happens syncronously in the current queue.
///                         Default value is `nil`.
///   - baseURL:            The URL to use `apiQuery` on.
///   - completion:         A closure that is called after a responce is received.
internal func fetch<T : JSONRepresentable>(
    using jsonData: Data?,
    apiQuery: String,
    dispatchQueue: DispatchQueue?,
    baseURL: URL,
    completion: @escaping (Result<T>) -> Void) {
    
    _fetch(using: jsonData,
           apiQuery: apiQuery,
           dispatchQueue: dispatchQueue,
           baseURL: baseURL,
           map: mapToValue,
           completion: completion)
}

internal func fetch<T : JSONRepresentable>(
    using jsonData: Data?,
    apiQuery: String,
    dispatchQueue: DispatchQueue?,
    baseURL: URL,
    completion: @escaping (Result<[T]>) -> Void) {
    
    _fetch(using: jsonData,
           apiQuery: apiQuery,
           dispatchQueue: dispatchQueue,
           baseURL: baseURL,
           map: mapToArray,
           completion: completion)
}
