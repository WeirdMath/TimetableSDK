//
//  Timetable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import SwiftyJSON

public final class Timetable {
    
    public static let defaultBaseURL = URL(string: "http://timetable.spbu.ru/api/v1/")!
    
    public let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public init() {
        baseURL = Timetable.defaultBaseURL
    }
    
    public fileprivate(set) var divisions: [Division]?
    
    public func fetchDivisions(using jsonData: Data? = nil,
                               dispatchQueue: DispatchQueue? = nil,
                               completion: ((Error?) -> Void)?) {
        
        _fetch(using: jsonData,
               dispatchQueue: dispatchQueue,
               baseURL: baseURL,
               completion: completion)
    }
    
    public func fetchStudyLevels(for division: Division,
                                 using jsonData: Data? = nil,
                                 dispatchQueue: DispatchQueue? = nil,
                                 recursively: Bool = false,
                                 completion: ((Error?) -> Void)?) {
        
        division._fetch(using: jsonData,
                        dispatchQueue: dispatchQueue,
                        baseURL: baseURL,
                        completion: completion)
    }
    
    public func fetchStudentGroups(for admissionYear: AdmissionYear,
                                   using jsonData: Data? = nil,
                                   dispatchQueue: DispatchQueue? = nil,
                                   completion: ((Error?) -> Void)?) {
        
        admissionYear._fetch(using: jsonData,
                             dispatchQueue: dispatchQueue,
                             baseURL: baseURL,
                             completion: completion)
    }
    
    public func fetchCurrentWeek(for studentGroup: StudentGroup,
                          using jsonData: Data? = nil,
                          dispatchQueue: DispatchQueue? = nil,
                          completion: ((Error?) -> Void)?) {
        
        studentGroup._fetch(using: jsonData,
                            dispatchQueue: dispatchQueue,
                            baseURL: baseURL,
                            completion: completion)
    }
}

extension Timetable: _APIQueryable {
    
    internal var _apiQuery: String {
        return "divisions"
    }
    
    internal func _saveFetchResult(_ json: JSON) throws {
        
        if let divisions = json.array?.flatMap(Division.init), !divisions.isEmpty {
            self.divisions = divisions
        } else {
            throw TimetableError.incorrectJSONFormat(json)
        }
    }
}
