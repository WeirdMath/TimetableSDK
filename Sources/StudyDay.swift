//
//  StudyDay.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import Foundation
import SwiftyJSON
import DefaultStringConvertible

/// The information about a day in a `Week`.
public struct StudyDay : JSONRepresentable {
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    public let date: Date
    
    public let name: String
    
    public let events: [StudyEvent]
}

extension StudyDay {
    
    internal init(from json: JSON) throws {
        date    = try map(json["Day"], transformation: StudyDay.dateFormatter.date(from:))
        name    = try map(json["DayString"])
        events  = try map(json["DayStudyEvents"])
    }
}

extension StudyDay: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: StudyDay, rhs: StudyDay) -> Bool{
        return
            lhs.date    == rhs.date     &&
            lhs.name    == rhs.name     &&
            lhs.events  == rhs.events
    }
}

extension StudyDay: CustomStringConvertible {}
