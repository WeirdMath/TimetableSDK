//
//  JSONRepresentable.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import Foundation
import SwiftyJSON

internal protocol JSONRepresentable {
    
    init?(from json: JSON)
}

internal extension JSONRepresentable {
    
    internal init?(from jsonData: Data) {
        let json = JSON(data: jsonData)
        self.init(from: json)
    }
    
    internal init?(from jsonString: String) {
        
        guard let data = jsonString.data(using: .utf8) else { return nil }
        
        self.init(from: data)
    }
}
