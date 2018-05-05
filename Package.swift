// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "scrape",
    products: [
        .library(
            name:"scrapeLib",
            type:.dynamic,
            targets: ["scrapeLib"]
        ),
        .executable(
            name: "scrape",
            targets: ["scrape"]
        )
    ],
    dependencies:[
        .package(url: "https://github.com/fcanas/HLSCore.git", from: "0.0.3"),
        .package(url: "https://github.com/fcanas/FFCLog.git", from:"0.0.1")
    ],
    targets: [
        .target(name: "scrape", dependencies: ["scrapeLib", "FFCLog"]),
        .target(name: "scrapeLib", dependencies: ["HLSCore", "FFCLog"]),
        .testTarget(name: "scrapeTests", dependencies: ["scrapeLib"])
    ]
)
