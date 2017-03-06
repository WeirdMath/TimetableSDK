# Change Log

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
