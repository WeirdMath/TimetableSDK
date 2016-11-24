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

internal protocol _APIQueryable: class {
    
    var _apiQuery: String { get }
    
    func _saveFetchResult(_ json: JSON) throws
}

internal extension _APIQueryable {
    
    internal func _fetch(using jsonData: Data?,
                         dispatchQueue: DispatchQueue?,
                         baseURL: URL,
                         completion: ((Error?) -> Void)?) {
        
        if let jsonData = jsonData {
            do {
                try _saveFetchResult(JSON(data: jsonData))
            } catch {
                completion?(error)
                return
            }
            
            completion?(nil)
        } else {
            Alamofire
                .request(baseURL.appendingPathComponent(_apiQuery))
                .responseData(queue: dispatchQueue) { [weak self] response in
                    
                    switch response.result {
                        
                    case .success(let data):
                        do {
                            try self?._saveFetchResult(JSON(data: data))
                        } catch {
                            completion?(error)
                            return
                        }
                        
                        completion?(nil)
                        
                    case .failure(let error):
                        completion?(error)
                    }
            }
        }
    }
}
