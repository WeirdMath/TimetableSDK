//
//  Operators.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 03.12.2016.
//
//

internal func ==<T : Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}

internal func ==<S : Equatable, T : Equatable>(lhs: [(S, T)], rhs: [(S, T)]) -> Bool {
    return zip(lhs, rhs).reduce(true, { $0 && $1.0 == $1.1 })
}

internal func ==<S : Equatable, T : Equatable>(lhs: [(S, T)]?, rhs: [(S, T)]?) -> Bool {
        switch (lhs, rhs) {
    case (.some(let lhs), .some(let rhs)):
        return lhs == rhs
    case (.none, .none):
        return true
    default:
        return false
    }
}
