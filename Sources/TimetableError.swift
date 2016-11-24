//
//  TimetableError.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 24.11.2016.
//
//

import SwiftyJSON

public enum TimetableError: Error {
    case incorrectJSONFormat(JSON)
}
