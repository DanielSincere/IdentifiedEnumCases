// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "IdentifiedEnumCases",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
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
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.0"),
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
