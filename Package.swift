import PackageDescription

let package = Package(
    name: "Orca",
    dependencies: [
        .Package(url: "https://github.com/elliottminns/echo.git",
            majorVersion: 0),
        .Package(url: "../bson-osx",
                 majorVersion: 0)
    ]
)
