// swift-tools-version: 6.2
import PackageDescription
import Foundation

let packageRoot = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let objcRoot = packageRoot.appendingPathComponent("LNPopupController", isDirectory: true)
let privateRoot = objcRoot.appendingPathComponent("Private", isDirectory: true)

var objcSettings: [CSetting] = [
    .headerSearchPath("include"),
    .headerSearchPath("LNPopupController/Private"),
]

if let enumerator = FileManager.default.enumerator(
    at: privateRoot,
    includingPropertiesForKeys: [.isDirectoryKey],
    options: [.skipsHiddenFiles, .skipsPackageDescendants]
) {
    for case let url as URL in enumerator {
        guard (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
            continue
        }
        let relative = url.path.replacingOccurrences(of: packageRoot.path + "/", with: "")
        objcSettings.append(.headerSearchPath(relative))
    }
}

let package = Package(
    name: "LNPopupController",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "LNPopupController-ObjC", targets: ["LNPopupController-ObjC"]),
    ],
    targets: [
        .target(
            name: "LNPopupController-ObjC",
            path: ".",
            exclude: [
                "Info.plist",
                "LNPopupController.xcodeproj",
                "LNPopupController/Private/Swift",
            ],
            publicHeadersPath: "include",
            cSettings: objcSettings
        ),
    ]
)
