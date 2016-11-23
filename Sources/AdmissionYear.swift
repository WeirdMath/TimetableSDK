//
//  AdmissionYear.swift
//  TimetableSDK
//
//  Created by Sergej Jaskiewicz on 22.11.2016.
//
//

import SwiftyJSON
import DefaultStringConvertible

public struct AdmissionYear {
    
    public var isEmpty: Bool
    fileprivate static let _isEmptyJSONKey = "IsEmpty"
    
    public var divisionAlias: String
    fileprivate static let _divisionAliasJSONKey = "PublicDivisionAlias"
    
    public var studyProgramID: Int
    fileprivate static let _studyProgramIDJSONKey = "StudyProgramId"
    
    public var name: String
    fileprivate static let _nameJSONKey = "YearName"
    
    public var number: Int
    fileprivate static let _numberJSONKey = "YearNumber"
}

extension AdmissionYear: JSONRepresentable {
    
    internal init?(from json: JSON) {
        
        if let isEmpty = json[AdmissionYear._isEmptyJSONKey].bool {
            self.isEmpty = isEmpty
        } else {
            _jsonFailure(json: json, key: AdmissionYear._isEmptyJSONKey)
            return nil
        }
        
        if let divisionAlias = json[AdmissionYear._divisionAliasJSONKey].string {
            self.divisionAlias = divisionAlias
        } else {
            _jsonFailure(json: json, key: AdmissionYear._divisionAliasJSONKey)
            return nil
        }
        
        if let studyProgramID = json[AdmissionYear._studyProgramIDJSONKey].int {
            self.studyProgramID = studyProgramID
        } else {
            _jsonFailure(json: json, key: AdmissionYear._studyProgramIDJSONKey)
            return nil
        }
        
        if let name = json[AdmissionYear._nameJSONKey].string {
            self.name = name
        } else {
            _jsonFailure(json: json, key: AdmissionYear._nameJSONKey)
            return nil
        }
        
        if let number = json[AdmissionYear._numberJSONKey].int {
            self.number = number
        } else {
            _jsonFailure(json: json, key: AdmissionYear._numberJSONKey)
            return nil
        }
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
