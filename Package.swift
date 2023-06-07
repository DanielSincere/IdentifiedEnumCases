// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "IdentifiedEnumCases",
    platforms: [.macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "IdentifiedEnumCases",
            targets: ["IdentifiedEnumCases"]
        ),
        .executable(
            name: "urls",
            targets: ["URLsExample"]
        ),
        .executable(
            name: "nightshades",
            targets: ["NightshadesExample"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0-swift-5.9-DEVELOPMENT-SNAPSHOT-2023-04-25-b"),
    ],
    targets: [
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "IdentifiedEnumCasesMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "IdentifiedEnumCases", dependencies: ["IdentifiedEnumCasesMacro"]),

        // An example usage of the library, which is able to use the macro in its own code.
        .executableTarget(name: "URLsExample", dependencies: ["IdentifiedEnumCases"]),
        .executableTarget(name: "NightshadesExample", dependencies: ["IdentifiedEnumCases"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "MacroTests",
            dependencies: [
                "IdentifiedEnumCasesMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
