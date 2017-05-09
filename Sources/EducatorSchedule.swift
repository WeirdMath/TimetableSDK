//
//  EducatorSchedule.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 05.12.2016.
//
//

import Foundation
import SwiftyJSON

/// The information about an educator's schedule.
public final class EducatorSchedule : JSONRepresentable, TimetableEntity {
    
    fileprivate static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = .posix
        return dateFormatter
    }()
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable? {
        didSet {
            educatorEventsDays.forEach { $0.timetable = timetable }
        }
    }
    
    public let autumnTermLinkAvailable: Bool
    public let dateRangeDisplayText: String
    public let educatorDisplayText: String
    public let educatorEventsDays: [Day]
    public let educatorLongDisplayText: String
    public let educatorID: Int
    public let from: Date
    public let hasEvents: Bool
    public let isSpringTerm: Bool
    public let next: Int?
    public let springTermLinkAvailable: Bool
    public let title: String
    public let to: Date
    
    internal init(autumnTermLinkAvailable: Bool,
                  dateRangeDisplayText: String,
                  educatorDisplayText: String,
                  educatorEventsDays: [Day],
                  educatorLongDisplayText: String,
                  educatorID: Int,
                  from: Date,
                  hasEvents: Bool,
                  isSpringTerm: Bool,
                  next: Int?,
                  springTermLinkAvailable: Bool,
                  title: String,
                  to: Date) {
        self.autumnTermLinkAvailable = autumnTermLinkAvailable
        self.dateRangeDisplayText    = dateRangeDisplayText
        self.educatorDisplayText     = educatorDisplayText
        self.educatorEventsDays      = educatorEventsDays
        self.educatorLongDisplayText = educatorLongDisplayText
        self.educatorID              = educatorID
        self.from                    = from
        self.hasEvents               = hasEvents
        self.isSpringTerm            = isSpringTerm
        self.next                    = next
        self.springTermLinkAvailable = springTermLinkAvailable
        self.title                   = title
        self.to                      = to
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            autumnTermLinkAvailable = try map(json["AutumnTermLinkAvailable"])
            dateRangeDisplayText    = try map(json["DateRangeDisplayText"])
            educatorDisplayText     = try map(json["EducatorDisplayText"])
            educatorEventsDays      = try map(json["EducatorEventsDays"])
            educatorLongDisplayText = try map(json["EducatorLongDisplayText"])
            educatorID              = try map(json["EducatorMasterId"])
            from                    = try map(json["From"],
                                              transformation: EducatorSchedule.dateFormatter.date(from:))
            hasEvents               = try map(json["HasEvents"])
            isSpringTerm            = try map(json["IsSpringTerm"])
            next                    = try map(json["Next"])
            springTermLinkAvailable = try map(json["SpringTermLinkAvailable"])
            title                   = try map(json["Title"])
            to                      = try map(json["To"],
                                              transformation: EducatorSchedule.dateFormatter.date(from:))
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: EducatorSchedule.self)
        }
    }
}

extension EducatorSchedule : Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: EducatorSchedule, rhs: EducatorSchedule) -> Bool {
        return
            lhs.autumnTermLinkAvailable == rhs.autumnTermLinkAvailable  &&
            lhs.dateRangeDisplayText    == rhs.dateRangeDisplayText     &&
            lhs.educatorDisplayText     == rhs.educatorDisplayText      &&
            lhs.educatorEventsDays      == rhs.educatorEventsDays       &&
            lhs.educatorLongDisplayText == rhs.educatorLongDisplayText  &&
            lhs.educatorID              == rhs.educatorID               &&
            lhs.from                    == rhs.from                     &&
            lhs.hasEvents               == rhs.hasEvents                &&
            lhs.isSpringTerm            == rhs.isSpringTerm             &&
            lhs.next                    == rhs.next                     &&
            lhs.springTermLinkAvailable == rhs.springTermLinkAvailable  &&
            lhs.title                   == rhs.title                    &&
            lhs.to                      == rhs.to
    }
}
