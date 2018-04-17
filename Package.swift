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
        .package(url: "https://github.com/fcanas/HLSCore.git", .revision("93e65bd8d442fda25b74adfe43de074e675b4201")),
        .package(url: "https://github.com/fcanas/FFCLog.git", .revision("2065d65b29b6c6e296c204c094597e325a905121"))
    ],
    targets: [
        .target(name: "scrape", dependencies: ["scrapeLib", "FFCLog"]),
        .target(name: "scrapeLib", dependencies: ["HLSCore", "FFCLog"]),
        .testTarget(name: "scrapeTests", dependencies: ["scrapeLib"])
    ]
)
