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
        .package(url: "https://github.com/fcanas/HLSCore.git", .upToNextMinor(from: "0.0.2"))
    ],
    targets: [
        .target(name: "scrape", dependencies: ["scrapeLib"]),
        .target(name: "scrapeLib", dependencies: ["HLSCore"]),
        .testTarget(name: "scrapeTests", dependencies: ["scrapeLib"])
    ]
)
