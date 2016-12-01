//
//  TimetableEntity.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 01.12.2016.
//
//

internal protocol TimetableEntity {
    /// The Timetable this entity was fetched from. `nil` if it was initialized from a custom JSON object.
    weak var timetable: Timetable? { get set }
}
