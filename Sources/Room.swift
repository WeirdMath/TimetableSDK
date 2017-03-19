//
//  Room.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 07.03.2017.
//
//

import Foundation
import SwiftyJSON

/// A room. Every `Event` takes place in some room.
public final class Room : JSONRepresentable, TimetableEntity {

    public enum Seating : Int {
        case theater = 0, amphitheater, roundaTable
    }

    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?

    /// The address of a building where the room is located.
    public weak var address: Address?

    /// This property is not `nil` only if the week has been initialized
    /// using `init(from:)`.
    private var _json: JSON?

    public let name: String
    public let seating: Seating
    public let capacity: Int
    public let additionalInfo: String
    public let wantingEquipment: String?
    public let oid: String

    internal init(name: String,
                  seating: Seating,
                  capacity: Int,
                  additionalInfo: String,
                  wantingEquipment: String?,
                  oid: String) {
        self.name = name
        self.seating = seating
        self.capacity = capacity
        self.additionalInfo = additionalInfo
        self.wantingEquipment = wantingEquipment
        self.oid = oid
    }

    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameters:
    ///   - json: The JSON representation of the entity.
    ///   - timetable: The timetable object to bind to. Default is `nil`.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON, bindingTo timetable: Timetable?) throws {
        do {
            name = try map(json["DisplayName1"])

            if let _seating = Seating(rawValue: try map(json["SeatingType"])) {
                seating = _seating
            } else {
                throw TimetableError.incorrectJSON(json, whenConverting: Room.self)
            }

            capacity = try map(json["Capacity"])
            additionalInfo = try map(json["AdditionalInfo"])
            wantingEquipment = try map(json["wantingEquipment"])
            oid = try map(json["Oid"])

            _json = json
            self.timetable = timetable
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Room.self)
        }
    }

    public convenience init(from jsonData: Data, bindingTo timetable: Timetable?) throws {
        try self.init(from: jsonData)
        self.timetable = timetable
    }

    public convenience init(from json: JSON) throws {
        try self.init(from: json, bindingTo: nil)
    }
}

extension Room : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Room, rhs: Room) -> Bool {
        return
            lhs.name                == rhs.name             &&
            lhs.oid                 == rhs.oid              &&
            lhs.seating             == rhs.seating          &&
            lhs.capacity            == rhs.capacity         &&
            lhs.additionalInfo      == rhs.additionalInfo   &&
            lhs.wantingEquipment    == rhs.wantingEquipment
    }
}
