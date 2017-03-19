import PackageDescription

let package = Package(
    name: "TimetableSDK",
    dependencies: [
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", majorVersion: 3),
        .Package(url: "https://github.com/mxcl/PromiseKit.git", majorVersion: 4),
    ]
)
