//
//  Timetable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public final class Timetable {
    
    public static let defaultBaseURL = URL(string: "http://timetable.spbu.ru/api/v1/")!
    
    private static let _getDivisions = "divisions"
    
    public let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public init() {
        baseURL = Timetable.defaultBaseURL
    }
    
    public private(set) var divisions: [Division]?
    
    public func fetchDivisions(using jsonData: Data? = nil,
                               dispatchQueue: DispatchQueue? = nil,
                               completion: ((Error?) -> Void)?) {
        
        if let jsonData = jsonData {
            do {
                divisions = try _divisions(from: jsonData)
            } catch {
                completion?(error)
                return
            }
            
            completion?(nil)
        } else {
            _fetchDivisionsFromWWW(dispatchQueue: dispatchQueue, completion)
        }
    }
    
    private func _fetchDivisionsFromWWW(dispatchQueue: DispatchQueue?,
                                        _ completion: ((Error?) -> Void)?) {
        
        Alamofire
            .request(baseURL.appendingPathComponent(Timetable._getDivisions))
            .responseData(queue: dispatchQueue) { [weak self] response in
                
                switch response.result {
                    
                case .success(let data):
                    do {
                        self?.divisions = try self?._divisions(from: data)
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
    
    private func _divisions(from jsonData: Data) throws -> [Division] {
        
        let json = JSON(data: jsonData)
        
        if let divisions = json.array?.flatMap(Division.init), !divisions.isEmpty {
            return divisions
        } else {
            throw TimetableError.incorrectJSONFormat
        }
    }
}
