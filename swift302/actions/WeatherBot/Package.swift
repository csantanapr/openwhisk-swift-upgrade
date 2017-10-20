import PackageDescription

let package = Package(
    name: "Action",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/CCurl.git", "0.2.3"),
        .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.0.1"),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "14.2.0")
    ]
)
