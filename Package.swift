import PackageDescription

let package = Package(
    name: "Orca",
    dependencies: [
        .Package(url: "https://github.com/elliottminns/echo.git",
            majorVersion: 0)
    ]
)
