# Change Log

## [3.1.1](https://github.com/WeirdMath/TimetableSDK/tree/3.1.0) (2017-04-17)

- Fixed not setting the `studentGroup` property for fetched next and previous weeks

## [3.1.0](https://github.com/WeirdMath/TimetableSDK/tree/3.1.0) (2017-04-08)

- Now when calling a fetching method, you can disable force reloading. I. e. if somthing has already been fetched and saved to a property of a class that provides the fetching method, calling that method with `forceReload: false` returns the contents of that property.
- You can now fetch extracurricular events for a division (currently Liberal Arts and Science only).

## [3.0.0](https://github.com/WeirdMath/TimetableSDK/tree/3.0.0) (2017-03-19)

- Dropped Alamofire and DefaultStringConvertible dependencies.
- `Result` type in now implemented as follows:

    ```swift
    public enum Result<Value> {
        case success(Value)
        case failure(TimetableError)
    }
    ```


## [2.2.0](https://github.com/WeirdMath/TimetableSDK/tree/2.2.0) (2017-03-08)

**Implemented features:**

- Created `Address` and `Room` entities.
- `Location` can now fetch the room that it refers to, if one can be found (which is not guaranteed even if there actually is such room, but its address does not match exactly to the location's address).
- Some docs fixed.
- Fixed not setting the `timetable` property for some entities.
- `Event` and `Location` were made classes.

## [2.1.0](https://github.com/WeirdMath/TimetableSDK/tree/2.1.0) (2017-03-06)

**Implemented features:**

- Serializing `StudentGroup`s and `Week`s using JSON. This is useful when you don't want to fetch them every time you need them.
- Initializing `StudentGroup`s and `Week`s from JSON with binding to a `Timetable` object so you can invoke their `fetch[...]` methods safely.

## [2.0.1](https://github.com/WeirdMath/TimetableSDK/tree/2.0.1) (2017-03-04)

**Issues resolved:**

- After fetching `StudyLevel`s each of the containing `Specialization`'s `timetable` property had not been set. Same thing for `AdmissionYear`'s `timetable`. It has been fixed in this patch.

## [2.0.0](https://github.com/WeirdMath/TimetableSDK/tree/2.0.0) (2016-12-05)

**Implemented features:**

- The [Timetable API](http://timetable.spbu.ru/help/ui/index) has been updated. The new version provides a model that reflects the changes.
- Completion handlers are now of type `(Result<T>) -> Void`.
- Some properties of `Event` have been made optional in order to generalize this entity so that it fits more API responses.
- Most of the entities have been made classes instead of structs.
- Fetching methods are now not only members of the `Timetable` class.
- Support for promises using [PromiseKit](http://promisekit.org).
- Massive refactoring for object mapping and other internals. Compiles faster, code coverage increased.

## [1.0.0](https://github.com/WeirdMath/TimetableSDK/tree/1.0.0) (2016-11-25)

**Implemented features:**

- Deserializing [Timetable API responses](http://timetable.spbu.ru/help/ui/index) into
a nice strongly typed model.
- Convenient API for fetching data from [timetable.spbu.ru](http://timetable.spbu.ru).
- Mocking the service responce with `*.json` files for testing purposes.
