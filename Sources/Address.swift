//
//  Address.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 07.03.2017.
//
//

import Foundation
import enum Alamofire.Result
import SwiftyJSON
import DefaultStringConvertible
import PromiseKit

/// The information about an address of a building.
public final class Address : JSONRepresentable, TimetableEntity {

    /// The Timetable this entity was fetched from or bound to.
    public weak var timetable: Timetable?

    public let name: String
    public let matches: Int
    public let wantingEquipment: String?
    public let oid: String

    /// This property is not `nil` only if the address has been initialized
    /// using `init(from:)`.
    private var _json: JSON?

    /// The rooms available in this address. Initially is `nil`. Use
    /// the `fetchAllRooms(using:dispatchQueue:completion)` method ind order to get the rooms.
    public internal(set) var rooms: [Room]?
    internal var roomsAPIQuery: String {
        return "address/\(oid)/locations"
    }

    internal init(name: String, matches: Int, wantingEquipment: String?, oid: String) {
        self.name = name
        self.matches = matches
        self.wantingEquipment = wantingEquipment
        self.oid = oid
    }

    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameters:
    ///   - json: The JSON representation of the entity.
    ///   - timetable: The timetable object to bind to. Default is `nil`.
    ///                Set this to non-`nil` value if you want to use the
    ///                `fetchRooms` and `fetchAllRooms` methods.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON, bindintTo timetable: Timetable?) throws {
        do {
            name             = try map(json["DisplayName1"])
            matches          = try map(json["matches"])
            wantingEquipment = try map(json["wantingEquipment"])
            oid              = try map(json["Oid"])

            _json = json
            self.timetable = timetable
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Address.self)
        }
    }

    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameters:
    ///   - json: The JSON representation of the entity.
    ///   - timetable: The timetable object to bind to. Default is `nil`.
    ///                Set this to non-`nil` value if you want to use the
    ///                `fetchRooms` and `fetchAllRooms` methods.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public convenience init(from jsonData: Data, bindingTo timetable: Timetable?) throws {
        try self.init(from: jsonData)
        self.timetable = timetable
    }

    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public convenience init(from json: JSON) throws {
        try self.init(from: json, bindintTo: nil)
    }

    /// Fetches all the rooms available in this address.
    ///
    /// - Parameters:
    ///   - jsonData:       If this is not `nil`, then instead of networking uses provided json data as mock
    ///                     data. May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchAllRooms(using jsonData: Data? = nil,
                              dispatchQueue: DispatchQueue? = nil,
                              completion: @escaping (Result<[Room]>) -> Void) {

        fetch(using: jsonData,
              apiQuery: roomsAPIQuery,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { [weak self] (result: Result<[Room]>) in

                if case .success(let rooms) = result {
                    self?.rooms = rooms

                    rooms.forEach { $0.address = self }
                }

                completion(result)
        }
    }

    /// Fetches  the rooms available in this address that satisfy the provided `parameters`.
    ///
    /// - Parameters:
    ///   - seating:       The type of seating.
    ///   - capacity:      The capacity of a room.
    ///   - equipment:     The equipment needed.
    ///   - jsonData:      If this is not `nil`, then instead of networking uses provided json data as mock
    ///                    data. May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - dispatchQueue: If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                    execute a completion handler on. Otherwise uses the specified queue.
    ///                    If `jsonData` is not `nil`, setting this
    ///                    makes no change as in this case fetching happens syncronously in the current queue.
    ///   - completion:    A closure that is called after a responce is received.
    public func fetchRooms(seating: Room.Seating?,
                           capacity: Int?,
                           equipment: String?,
                           using jsonData: Data? = nil,
                           dispatchQueue: DispatchQueue? = nil,
                           completion: @escaping (Result<[Room]>) -> Void) {

        var parameters: [String : Any] = [:]

        parameters["seating"] = seating?.rawValue
        parameters["capacity"] = capacity
        parameters["equipment"] = equipment

        fetch(using: jsonData,
              apiQuery: roomsAPIQuery,
              parameters: parameters,
              dispatchQueue: dispatchQueue,
              timetable: timetable) { (result: Result<[Room]>) in

                if case .success(let rooms) = result {
                    rooms.forEach { $0.address = self }
                }

                completion(result)
        }
    }

    /// Fetches all the rooms available in this address.
    ///
    /// - Parameter jsonData: If this is not `nil`, then instead of networking uses provided json data as mock
    ///                       data. May be useful for deserializing from a local storage. Default value is `nil`.
    /// - Returns:            A promise.
    public func fetchAllRooms(using jsonData: Data? = nil) -> Promise<[Room]> {
        return makePromise({ fetchAllRooms(using: jsonData, completion: $0) })
    }

    /// Fetches  the rooms available in this address that satisfy the provided `parameters`.
    ///
    /// - Parameters:
    ///   - seating:   The type of seating.
    ///   - capacity:  The capacity of a room.
    ///   - equipment: The equipment needed.
    ///   - jsonData:  If this is not `nil`, then instead of networking uses provided json data as mock
    ///                data. May be useful for deserializing from a local storage. Default value is `nil`.
    /// - Returns:     A promise.
    public func fetchRooms(seating: Room.Seating?,
                           capacity: Int?,
                           equipment: String?,
                           using jsonData: Data? = nil) -> Promise<[Room]> {
        return makePromise({ fetchRooms(seating: seating,
                                        capacity: capacity,
                                        equipment: equipment,
                                        using: jsonData,
                                        completion: $0) })
    }
}

extension Address : Equatable {

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Address, rhs: Address) -> Bool{
        return
            lhs.name                == rhs.name             &&
            lhs.matches             == rhs.matches          &&
            lhs.wantingEquipment    == rhs.wantingEquipment &&
            lhs.oid                 == rhs.oid
    }
}

extension Address : CustomStringConvertible {}
