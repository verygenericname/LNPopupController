// swift-tools-version:6.2
// LNPopupController:4.6.1

import PackageDescription
import Foundation

let packageBase = URL(
    filePath: Context.packageDirectory,
    directoryHint: .isDirectory
)

let objcTargetPath = "LNPopupController"
let objcTargetDirectory = packageBase.appending(
    component: objcTargetPath,
    directoryHint: .isDirectory
)

let privateDirectory = objcTargetDirectory.appending(
    component: "LNPopupController/Private",
    directoryHint: .isDirectory
)

// Header search paths are relative to the LNPopupController target directory.
var settings: [CSetting] = [
    .headerSearchPath("LNPopupController/Private")
]

if let enumerator = FileManager.default.enumerator(
    at: privateDirectory,
    includingPropertiesForKeys: [.isDirectoryKey],
    options: [.skipsHiddenFiles, .skipsPackageDescendants]
) {
    for case let fileURL as URL in enumerator {
        do {
            let attributes = try fileURL.resourceValues(
                forKeys: [.isDirectoryKey]
            )

            if attributes.isDirectory == true {
		let relativePath = String(
    			fileURL.path.dropFirst(objcTargetDirectory.path.count + 1)
		)
                settings.append(.headerSearchPath(relativePath))
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

let package = Package(
    name: "LNPopupController",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "LNPopupController",
            type: .dynamic,
            targets: [
                "LNPopupController",
                "LNPopupController-ObjC",
                "LNPopupController-SwiftPrivate"
            ]
        ),
        .library(
            name: "LNPopupController-Static",
            type: .static,
            targets: [
                "LNPopupController",
                "LNPopupController-ObjC",
                "LNPopupController-SwiftPrivate"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/LeoNatan/LNSystemMarqueeLabel",
            from: Version(stringLiteral: "0.1.2")
        )
    ],
    targets: [
        .target(
            name: "LNPopupController-ObjC",
            dependencies: [
                .product(
                    name: "LNSystemMarqueeLabel",
                    package: "LNSystemMarqueeLabel"
                )
            ],
            path: "LNPopupController",
            exclude: [
                "Info.plist",
                "LNPopupController.xcodeproj",
                "LNPopupController/Private/Swift"
            ],
            publicHeadersPath: "include",
            cSettings: settings
        ),
        .target(
            name: "LNPopupController-SwiftPrivate",
            dependencies: ["LNPopupController-ObjC"],
            path: "LNPopupController/LNPopupController/Private/Swift"
        ),
        .target(
            name: "LNPopupController",
            dependencies: ["LNPopupController-ObjC"],
            path: "LNPopupController+Swift"
        )
    ],
    cxxLanguageStandard: .gnucxx20
)
