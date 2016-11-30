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
        .Package(url: "https://github.com/WeirdMath/TimetableSDK.git", majorVersion: 2)
    ]
)
```

## Usage

You can use the SDK for getting data directly from [timetable.spbu.ru](http://timetable.spbu.ru):

```swift
import TimetableSDK

let timetable = Timetable()

timetable.fetchDivisions { error in

    if let error = error {
        print(error)
        return
    }

    let physics = timetable.divisions![19]

    print(physics.name)
    // Prints "Физика"

    timetable.fetchStudyLevels(for: physics) { error in

        if let error = error {
            print(error)
            return
        }

        print(physics.studyLevels![0].specializations[0].name)
        // Prints "Информационные технологии и численные методы"
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

timetable.fetchDivisions(using: jsonData) { error in
    // ...
}
```

You can specify a dispatch queue if you need to:
```swift
import Dispatch
import TimetableSDK

timetable.fetchDivisions(dispatchQueue: .global(qos: .background)) { error in
    // ...
}
```

## Contributing

In order to generate an Xcode project for TimetableSDK execute the following command in the root directory of the project:

```
$ swift package generate-xcodeproj
```
