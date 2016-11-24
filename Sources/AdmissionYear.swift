//
//  AdmissionYear.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public final class AdmissionYear {
    
    public let isEmpty: Bool
    fileprivate static let _isEmptyJSONKey = "IsEmpty"
    
    public let divisionAlias: String
    fileprivate static let _divisionAliasJSONKey = "PublicDivisionAlias"
    
    public let studyProgramID: Int
    fileprivate static let _studyProgramIDJSONKey = "StudyProgramId"
    
    public let name: String
    fileprivate static let _nameJSONKey = "YearName"
    
    public let number: Int
    fileprivate static let _numberJSONKey = "YearNumber"
    
    public fileprivate(set) var studentGroups: [StudentGroup]?
    
    internal init(isEmpty: Bool,
                  divisionAlias: String,
                  studyProgramID: Int,
                  name: String,
                  number: Int) {
        
        self.isEmpty = isEmpty
        self.divisionAlias = divisionAlias
        self.studyProgramID = studyProgramID
        self.name = name
        self.number = number
    }
}

extension AdmissionYear: _APIQueryable {
    
    var _apiQuery: String {
        return "\(divisionAlias)/studyprogram/\(studyProgramID)/studentgroups"
    }
    
    func _saveFetchResult(_ json: JSON) throws {
        
        if let studentGroups = json.array?.flatMap(StudentGroup.init), !studentGroups.isEmpty {
            self.studentGroups = studentGroups
        } else {
            throw TimetableError.incorrectJSONFormat
        }
    }
}

extension AdmissionYear: JSONRepresentable {
    
    internal convenience init?(from json: JSON) {
        
        guard let isEmpty = json[AdmissionYear._isEmptyJSONKey].bool else {
            _jsonFailure(json: json, key: AdmissionYear._isEmptyJSONKey)
            return nil
        }
        
        guard let divisionAlias = json[AdmissionYear._divisionAliasJSONKey].string else {
            _jsonFailure(json: json, key: AdmissionYear._divisionAliasJSONKey)
            return nil
        }
        
        guard let studyProgramID = json[AdmissionYear._studyProgramIDJSONKey].int else {
            _jsonFailure(json: json, key: AdmissionYear._studyProgramIDJSONKey)
            return nil
        }
        
        guard let name = json[AdmissionYear._nameJSONKey].string else {
            _jsonFailure(json: json, key: AdmissionYear._nameJSONKey)
            return nil
        }
        
        guard let number = json[AdmissionYear._numberJSONKey].int else {
            _jsonFailure(json: json, key: AdmissionYear._numberJSONKey)
            return nil
        }
        
        self.init(isEmpty: isEmpty,
                  divisionAlias: divisionAlias,
                  studyProgramID: studyProgramID,
                  name: name,
                  number: number)
    }
}

extension AdmissionYear: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: AdmissionYear, rhs: AdmissionYear) -> Bool{
        return
            lhs.isEmpty         == rhs.isEmpty          &&
            lhs.divisionAlias   == rhs.divisionAlias    &&
            lhs.studyProgramID  == rhs.studyProgramID   &&
            lhs.name            == rhs.name             &&
            lhs.number          == rhs.number
    }
}

extension AdmissionYear: CustomStringConvertible {}
