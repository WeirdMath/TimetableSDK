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
    
    init(from json: JSON) throws
}

internal extension JSONRepresentable {
    
    internal init(from jsonData: Data) throws {
        let json = JSON(data: jsonData)
        try self.init(from: json)
    }
}

// MARK: - Standard type extensions
extension Double : JSONRepresentable {
    init(from json: JSON) throws {
        if let double = json.double {
            self.init(double)
        } else {
            throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to Double")
        }
    }
}

extension Int : JSONRepresentable {
    init(from json: JSON) throws {
        if let int = json.int {
            self.init(int)
        } else {
            throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to Int")
        }
    }
}

extension String : JSONRepresentable {
    init(from json: JSON) throws {
        if let string = json.string {
            self.init(string.characters)
        } else {
            throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to String")
        }
    }
}

extension Bool : JSONRepresentable {
    init(from json: JSON) throws {
        if let bool = json.bool {
            self.init(bool)
        } else {
            throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to Bool")
        }
    }
}

// MARK: - Mapping functions

internal func map<T : JSONRepresentable>(_ json: JSON) throws -> T {
    return try T(from: json)
}

internal func map<T : JSONRepresentable>(_ json: JSON) throws -> T? {
    if json.null != nil || !json.exists() {
        return nil
    } else {
        let result: T = try map(json)
        return result
    }
}

internal func map<T : JSONRepresentable>(_ json: JSON) throws -> [T] {
    if let array = json.array {
        return try array.map(T.init)
    } else {
        throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to Array")
    }
}

internal func map<T : JSONRepresentable>(_ json: JSON) throws -> [T]? {
    if json.null != nil || !json.exists() {
        return nil
    } else {
        let result: [T] = try map(json)
        return result
    }
}

internal func map<T : JSONRepresentable, S : JSONRepresentable>(_ json: JSON) throws -> (T, S) {
    return (try T(from: json["Item1"]), try S(from: json["Item2"]))
}

internal func map<T : JSONRepresentable, S : JSONRepresentable>(_ json: JSON) throws -> [(T, S)] {
    if let array = json.array {
        return try array.map(map)
    } else {
        throw TimetableError.incorrectJSONFormat(json, description: "Could not convert JSON to Array")
    }
}

internal func map<T : JSONRepresentable, S : JSONRepresentable>(_ json: JSON) throws -> [(T, S)]? {
    if json.null != nil || !json.exists() {
        return nil
    } else {
        let result: [(T, S)] = try map(json)
        return result
    }
}

internal func map<T, S : JSONRepresentable>(_ json: JSON, transformation: (S) -> T) throws -> T {
    return try transformation(S(from: json))
}

internal func map<T, S : JSONRepresentable>(_ json: JSON, transformation: (S) -> T?) throws -> T? {
    if json.null != nil || !json.exists() {
        return nil
    } else {
        let result: T = try map(json, transformation: transformation)
        return result
    }
}

internal func map<T, S : JSONRepresentable>(_ json: JSON, transformation: (S) -> T) throws -> T? {
    if json.null != nil || !json.exists() {
        return nil
    } else {
        let result: T = try map(json, transformation: transformation)
        return result
    }
}

internal func map<T, S : JSONRepresentable>(_ json: JSON, transformation: (S) -> T?) throws -> T {
    if let result = try transformation(S(from: json)) {
        return result
    } else {
        throw TimetableError.incorrectJSONFormat(json, description: "Could not apply a transformation")
    }
}
