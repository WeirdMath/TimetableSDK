//
//  TestHelpers.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import XCTest

extension XCTestCase {
    
    func getURLForTestingResource(forFile file: String, ofType type: String?) -> URL? {
        return URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent("Resources/")
            .appendingPathComponent(file + (type == nil ? "" : "." + type!))
    }
    
    func getTestingResource(fromFile file: String, ofType type: String?) -> Data? {
        
        guard let url = getURLForTestingResource(forFile: file, ofType: type) else { return nil }
        
        return try? Data(contentsOf: url)
    }
}
