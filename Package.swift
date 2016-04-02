import PackageDescription

let package = Package(
    name: "Orca",
    dependencies: [
        .Package(url: "https://github.com/elliottminns/echo.git",
            majorVersion: 0),
        .Package(url: "https://github.com/elliottminns/orca-mongodb.git",
                 majorVersion: 0),
        .Package(url: "https://github.com/elliottminns/Swift-PureJsonSerializer.git",
            majorVersion: 1)
    ]
)
