//
//  Networking.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import Foundation
import SwiftyJSON

internal typealias Parameters = [String : Any]

private func _fetch<Entity>(using jsonData: Data?,
                    apiQuery: String,
                    parameters: Parameters?,
                    jsonPath: @escaping (JSON) -> JSON,
                    dispatchQueue: DispatchQueue?,
                    timetable: Timetable?,
                    map: @escaping (JSON) throws -> Entity,
                    completion: @escaping (Result<Entity>) -> Void) {
    
    if let jsonData = jsonData {
        do {
            completion(.success(try map(jsonPath(JSON(data: jsonData)))))
        } catch {
            completion(.failure(error as! TimetableError))
        }
    } else {
        
        guard let baseURL = timetable?.baseURL else {
            completion(.failure(TimetableError.timetableIsDeallocated))
            return
        }

        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(apiQuery),
                                          resolvingAgainstBaseURL: false)!

        urlComponents.queryItems = parameters?.map { parameter in
            URLQueryItem(name: parameter.key, value: String(describing: parameter.value))
        }

        let dataTask = URLSession.shared
            .dataTask(with: urlComponents.url!) { (data, response, error) in

                (dispatchQueue ?? .main).async {

                    if let error = error {
                        completion(.failure(TimetableError.networkingError(error)))
                    } else {
                        do {
                            completion(.success(try map(jsonPath(JSON(data: data!)))))
                        } catch {
                            completion(.failure(error as! TimetableError))
                        }
                    }
                }
            }

        dataTask.resume()
    }
}

/// Does all the networking things.
///
/// - Parameters:
///   - jsonData:           If this is not `nil`, then instead of networking uses provided json data as mock
///                         data. May be useful for testing locally.
///   - apiQuery:           An API method to request.
///   - parameters:         The parameters for the query.
///   - jsonPath:           The function that steps through the JSON hierarchy.
///   - dispatchQueue:      If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
///                         execute a completion handler on. Otherwise uses the specified queue.
///                         If `jsonData` is not `nil`, setting this
///                         makes no change as in this case fetching happens syncronously in the current queue.
///                         Default value is `nil`.
///   - baseURL:            The URL to use `apiQuery` on.
///   - completion:         A closure that is called after a responce is received.
internal func fetch<Entity : JSONRepresentable & TimetableEntity>(
    using jsonData: Data?,
    apiQuery: String,
    parameters: Parameters? = nil,
    jsonPath: @escaping (JSON) -> JSON = { $0 },
    dispatchQueue: DispatchQueue?,
    timetable: Timetable?,
    completion: @escaping (Result<Entity>) -> Void) {
    
    _fetch(using: jsonData,
           apiQuery: apiQuery,
           parameters: parameters,
           jsonPath: jsonPath,
           dispatchQueue: dispatchQueue,
           timetable: timetable,
           map: map) { (result: TimetableSDK.Result<Entity>) in
            
            switch result {
            case .success(var value):
                value.timetable = timetable
                completion(.success(value))
            case .failure:
                completion(result)
            }
    }
}

/// Does all the networking things.
///
/// - Parameters:
///   - jsonData:           If this is not `nil`, then instead of networking uses provided json data as mock
///                         data. May be useful for testing locally.
///   - apiQuery:           An API method to request.
///   - parameters:         The parameters for the query.
///   - jsonPath:           The function that steps through the JSON hierarchy.
///   - dispatchQueue:      If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
///                         execute a networking request on. Otherwise uses the specified queue.
///                         If `jsonData` is not `nil`, setting this
///                         makes no change as in this case fetching happens syncronously in the current queue.
///                         Default value is `nil`.
///   - baseURL:            The URL to use `apiQuery` on.
///   - completion:         A closure that is called after a responce is received.
internal func fetch<Entity : JSONRepresentable & TimetableEntity>(
    using jsonData: Data?,
    apiQuery: String,
    parameters: Parameters? = nil,
    jsonPath: @escaping (JSON) -> JSON = { $0 },
    dispatchQueue: DispatchQueue?,
    timetable: Timetable?,
    completion: @escaping (Result<[Entity]>) -> Void) {
    
    _fetch(using: jsonData,
           apiQuery: apiQuery,
           parameters: parameters,
           jsonPath: jsonPath,
           dispatchQueue: dispatchQueue,
           timetable: timetable,
           map: map) { (result: Result<[Entity]>) in
            
            switch result {
            case .success(let _value):
                let value = _value.map { _element -> Entity in
                    var element = _element
                    element.timetable = timetable
                    return element
                }
                completion(.success(value))
            case .failure:
                completion(result)
            }
    }
}
