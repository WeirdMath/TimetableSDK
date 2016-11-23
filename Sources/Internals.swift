//
//  Internals.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 23.11.2016.
//
//

import SwiftyJSON

internal func _jsonFailure(json: JSON, key: String, file: StaticString = #file) {
    print("Failed to initialize from JSON in \(file): \(key) has invalid value:")
    print(json[key])
}
