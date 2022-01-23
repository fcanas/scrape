// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "scrape",
    platforms: [.macOS(.v10_12)],
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
    dependencies: [
        .package(url: "https://github.com/fcanas/HLSCore.git", from: "0.2.1"),
        .package(url: "https://github.com/fcanas/FFCLog.git", from:"0.1.0")
    ],
    targets: [
        .executableTarget(name: "scrape", dependencies: ["scrapeLib", "FFCLog"]),
        .target(name: "scrapeLib", dependencies: ["HLSCore", "FFCLog"]),
        .testTarget(name: "scrapeTests", dependencies: ["scrapeLib"])
    ]
)
