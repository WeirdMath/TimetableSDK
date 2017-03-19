# TimetableSDK
[![Build Status](https://travis-ci.org/WeirdMath/TimetableSDK.svg?branch=master)](https://travis-ci.org/WeirdMath/TimetableSDK)
[![codecov](https://codecov.io/gh/WeirdMath/TimetableSDK/branch/master/graph/badge.svg)](https://codecov.io/gh/WeirdMath/TimetableSDK)
![Cocoapods](https://img.shields.io/cocoapods/v/TimetableSDK.svg?style=flat)

Simple SDK for macOS, iOS and watchOS that allows you to get the data you need from [timetable.spbu.ru](http://timetable.spbu.ru).

## Requirements

* Swift 3
* iOS 8.0+
* macOS 10.10+
* tvOS 9.0+
* watchOS 2.0+

## Installation

### CocoaPods

For the latest release in CocoaPods add the following to your `Podfile`:

```ruby
use_frameworks!

pod 'TimetableSDK'
```

### Swift Package Manager
Add TimetableSDK as a dependency to your `Package.swift`. For example:

```swift
let package = Package(
    name: "YourPackageName",
    dependencies: [
        .Package(url: "https://github.com/WeirdMath/TimetableSDK.git", majorVersion: 3)
    ]
)
```

## Usage

You can use the SDK for getting data directly from [timetable.spbu.ru](http://timetable.spbu.ru):

```swift
import TimetableSDK

let timetable = Timetable()

timetable.fetchDivisions() { result in
    
    switch result {
    case .success(let divisions):
        
        let physics = divisions[19]
        
        print(physics.name)
        // "Физика"
        
        physics.fetchStudyLevels(){ result in
            
            switch result {
            case .success(let studyLevels):
                
                print(studyLevels[0].specializations[0].name)
                // "Информационные технологии и численные методы"
                
            case .failure(let error):
                print(error)
            }
        }
    case .failure(let error):
        print(error)
    }
}
```

Or — if you want to just test your app and don't need networking — the data can be deserialized from
JSON files:

```swift
import Foundation
import TimetableSDK

let timetable = Timetable()

let url = Bundle.main.url(forResource: "divisions", withExtension: "json")!
let jsonData = try! Data(contentsOf: url)

timetable.fetchDivisions(using: jsonData) { result in
    // ...
}
```

You can specify a dispatch queue if you need to:

```swift
import Dispatch
import TimetableSDK

timetable.fetchDivisions(dispatchQueue: .global(qos: .background)) { result in
    // ...
}
```

You can use promises!

```swift
import TimetableSDK
import PromiseKit

let timetable = Timetable()

timetable.fetchDivisions().then { divisions -> Promise<[StudyLevel]> in
    
    let physics = divisions[19]
    
    print(physics.name)
    // "Физика"
    
    return physics.fetchStudyLevels()
    
}.then { studyLevels in

    print(studyLevels[0].specializations[0].name)
    // "Информационные технологии и численные методы"
    
}.catch { error in
    print(error)
}
```

## Contributing

In order to generate an Xcode project for TimetableSDK execute the following command in the root directory of the project:

```
$ swift package generate-xcodeproj
```
