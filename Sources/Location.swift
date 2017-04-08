//
//  Location.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import PromiseKit
import Foundation

/// The information about a location that an `Event` may take place in.
public final class Location : JSONRepresentable, TimetableEntity {
    
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    public weak var timetable: Timetable?

    /// The room that the current location refers to, if available.
    /// Use
    public var room: Room?
    
    public let educatorsDisplayText: String?
    public let hasEducators: Bool
    public let educatorIDs: [(Int, String)]?
    public let isEmpty: Bool
    public let displayName: String
    public let hasGeographicCoordinates: Bool
    public let latitude: Double?
    public let longitude: Double?
    public let latitudeValue: String?
    public let longitudeValue: String?
    
    internal init(educatorsDisplayText: String?,
                  hasEducators: Bool,
                  educatorIDs: [(Int, String)]?,
                  isEmpty: Bool,
                  displayName: String,
                  hasGeographicCoordinates: Bool,
                  latitude: Double?,
                  longitude: Double?,
                  latitudeValue: String?,
                  longitudeValue: String?) {
        self.educatorsDisplayText     = educatorsDisplayText
        self.hasEducators             = hasEducators
        self.educatorIDs              = educatorIDs
        self.isEmpty                  = isEmpty
        self.displayName              = displayName
        self.hasGeographicCoordinates = hasGeographicCoordinates
        self.latitude                 = latitude
        self.longitude                = longitude
        self.latitudeValue            = latitudeValue
        self.longitudeValue           = longitudeValue
    }
    
    /// Creates a new entity from its JSON representation.
    ///
    /// - Parameter json: The JSON representation of the entity.
    /// - Throws: `TimetableError.incorrectJSONFormat`
    public init(from json: JSON) throws {
        do {
            educatorsDisplayText        = try map(json["EducatorsDisplayText"])
            hasEducators                = (try? map(json["HasEducators"])) ?? false
            educatorIDs                 = try map(json["EducatorIds"])
            isEmpty                     = try map(json["IsEmpty"])
            displayName                 = try map(json["DisplayName"])
            hasGeographicCoordinates    = try map(json["HasGeographicCoordinates"])
            
            if hasGeographicCoordinates {
                latitude                = try map(json["Latitude"])
                longitude               = try map(json["Longitude"])
                latitudeValue           = try map(json["LatitudeValue"])
                longitudeValue          = try map(json["LongitudeValue"])
                
            } else {
                latitude = nil
                longitude = nil
                latitudeValue = nil
                longitudeValue = nil
            }
        } catch {
            throw TimetableError.incorrectJSON(json, whenConverting: Location.self)
        }
    }

    /// Fetches the room that the current location refers to, if available. Saves it to the `room` property.
    /// 
    /// - Important: `timetable` property must be set.
    ///
    /// - Warning: This functionality is unstable, i. e. it is not guaranteed that the needed `Room` for this
    ///            location will actually be found. That's not my fault. It's Timetable ¯\\_(ツ)_/¯
    ///
    /// - Parameters:
    ///   - addressesData:  If this is not `nil`, then instead of networking uses provided json data for
    ///                     the list of addresses to search in.
    ///                     May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - roomsData:      If this is not `nil`, then instead of networking uses provided json data for
    ///                     the list of rooms to search in.
    ///                     May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - dispatchQueue:  If this is `nil`, uses `DispatchQueue.main` as a queue to asyncronously
    ///                     execute a completion handler on. Otherwise uses the specified queue.
    ///                     If `jsonData` is not `nil`, setting this
    ///                     makes no change as in this case fetching happens syncronously in the current queue.
    ///                     Default value is `nil`.
    ///   - forceReloadAddresses: This method needs to fetch all the addresses. This is expensive.
    ///                           See also
    ///                           `Timetable.fetchAllAddresses(using:dispatchQueue:forceReload:completion:)`.
    ///                           Default value is `false`.
    ///   - forceReloadRooms:     For a matching adress this method needs to fetch all the rooms.
    ///                           This is expensive. See also
    ///                           `Address.fetchAllRooms(using:dispatchQueue:forceReload:completion:)`.
    ///                           Default value is `false`.
    ///   - completion:     A closure that is called after a responce is received.
    public func fetchRoom(addressesData: Data? = nil,
                          roomsData: Data? = nil,
                          dispatchQueue: DispatchQueue? = nil,
                          forceReloadAddresses: Bool = false,
                          forceReloadRooms: Bool = false,
                          completion: @escaping (Result<Room>) -> Void) {

        guard let timetable = timetable else {
            completion(.failure(TimetableError.timetableIsDeallocated))
            return
        }

        timetable
            .fetchAllAddresses(using: addressesData,
                               dispatchQueue: dispatchQueue,
                               forceReload: forceReloadAddresses) { result in

                switch result {
                case .success(let addresses):

                    let selfName = self.displayName.lowercased()

                    guard let matchingAddress = addresses
                        .first(where: { selfName.contains($0.name.lowercased()) }) else {
                            completion(.failure(TimetableError.couldntFindRoomForLocation))
                            return
                    }

                    let addressPart = matchingAddress.name.lowercased()
                    let roomPart = selfName.replacingOccurrences(of: addressPart, with: "")

                    matchingAddress.fetchAllRooms(using: roomsData,
                                                  dispatchQueue: dispatchQueue,
                                                  forceReload: forceReloadRooms) { result in

                        switch result {
                        case .success(let rooms):

                            // Find the longest room name that contains in the roomPart.
                            var matchingRoom: Room?
                            var maxRoomNameLength = 0

                            for room in rooms {

                                let roomNameLength = room.name.characters.count

                                if roomNameLength > maxRoomNameLength &&
                                    roomPart.contains(room.name.lowercased()) {

                                    matchingRoom = room
                                    maxRoomNameLength = roomNameLength
                                }
                            }

                            if let matchingRoom = matchingRoom {
                                self.room = matchingRoom
                                completion(.success(matchingRoom))
                            } else {
                                completion(.failure(TimetableError.couldntFindRoomForLocation))
                            }

                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }

                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }

    /// Fetches the room that the current location refers to, if available. Saves it to the `room` property.
    ///
    /// - Important: `timetable` property must be set.
    ///
    /// - Parameters:
    ///   - addressesData:  If this is not `nil`, then instead of networking uses provided json data for
    ///                     the list of addresses to search in.
    ///                     May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - roomsData:      If this is not `nil`, then instead of networking uses provided json data for
    ///                     the list of rooms to search in.
    ///                     May be useful for deserializing from a local storage. Default value is `nil`.
    ///   - forceReloadAddresses: This method needs to fetch all the addresses. This is expensive.
    ///                           See also
    ///                           `Timetable.fetchAllAddresses(using:dispatchQueue:forceReload:completion:)`.
    ///                           Default value is `false`.
    ///   - forceReloadRooms:     For a matching adress this method needs to fetch all the rooms.
    ///                           This is expensive. See also
    ///                           `Address.fetchAllRooms(using:dispatchQueue:forceReload:completion:)`.
    ///                           Default value is `false`.
    /// - Returns: A promise.
    public func fetchRoom(addressesData: Data? = nil,
                          roomsData: Data? = nil,
                          forceReloadAddresses: Bool = false,
                          forceReloadRooms: Bool = false) -> Promise<Room> {
        return makePromise { fetchRoom(addressesData: addressesData,
                                       roomsData: roomsData,
                                       forceReloadAddresses: forceReloadAddresses,
                                       forceReloadRooms: forceReloadRooms,
                                       completion: $0) }
    }
}

extension Location: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        
        return
            lhs.educatorsDisplayText        == rhs.educatorsDisplayText                     &&
            lhs.hasEducators                == rhs.hasEducators                             &&
            lhs.educatorIDs                 == rhs.educatorIDs                              &&
            lhs.isEmpty                     == rhs.isEmpty                                  &&
            lhs.displayName                 == rhs.displayName                              &&
            lhs.hasGeographicCoordinates    == rhs.hasGeographicCoordinates                 &&
            lhs.latitude                    == rhs.latitude                                 &&
            lhs.longitude                   == rhs.longitude                                &&
            lhs.latitudeValue               == rhs.latitudeValue                            &&
            lhs.longitudeValue              == rhs.longitudeValue
    }
}
