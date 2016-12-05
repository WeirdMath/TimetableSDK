# Change Log

## [2.0.0](https://github.com/WeirdMath/TimetableSDK/tree/2.0.0) (2016-12-05)

**Implemented features:**

- The [Timetable API](http://timetable.spbu.ru/help/ui/index) has been updated. The new version provides a model that reflects the changes.
- Completion handlers are now of type `(Result<T>) -> Void`.
- Some properties of `Event` have been made optional in order to generalize this entity so that it fits more API responses.
- Most of the entities have been made classes instead of structs.
- Fetching methods are now not only members of the `Timetable` class.
- Massive refactoring for object mapping and other internals. Compiles faster, code coverage increased.

## [1.0.0](https://github.com/WeirdMath/TimetableSDK/tree/1.0.0) (2016-11-25)

**Implemented features:**

- Deserializing [Timetable API responses](http://timetable.spbu.ru/help/ui/index) into
a nice strongly typed model.
- Convenient API for fetching data from [timetable.spbu.ru](http://timetable.spbu.ru).
- Mocking the service responce with `*.json` files for testing purposes.