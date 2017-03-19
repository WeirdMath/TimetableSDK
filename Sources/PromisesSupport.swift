//
//  PromisesSupport.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 03.12.2016.
//
//

import PromiseKit
import Dispatch
import Foundation

/// Easy way for each fetching method (e. g. `timetable.fetchDivisions(using:dispatchQueue:completion)`) to
/// provide a similar method that returns a `Promise`.
///
/// - Parameter fetchingFunction: A default method that takes a completion handler.
///
/// - Returns: A promise.
internal func makePromise<S>(_ fetchingFunction: (
    _ completion: @escaping (_ result: Result<S>) -> Void) -> Void) -> Promise<S> {
    return Promise { fulfill, reject in
        fetchingFunction { result in
            switch result {
            case .success(let value):
                fulfill(value)
            case .failure(let error):
                reject(error)
            }
        }
    }
}
