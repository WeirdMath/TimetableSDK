//
//  Internals.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import SwiftyJSON

internal func _jsonFailure(json: JSON, key: String) {
    print("Failed to initialize from JSON: \(key) has invalid value:")
    print(json[key])
}
