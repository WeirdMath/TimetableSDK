//
//  Result.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 19.03.2017.
//
//

import Foundation

public enum Result<Value> {
    case success(Value)
    case failure(TimetableError)
}
