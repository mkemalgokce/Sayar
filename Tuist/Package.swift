// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    productTypes: [:],
    // Map our custom configurations to standard Debug/Release
    baseSettings: .settings(
        configurations: [
            .debug(name: "Dev"),
            .release(name: "UAT"),
            .release(name: "Prod")
        ]
    )
)
#endif

let package = Package(
    name: "Sayar",
    dependencies: [
        // Firebase iOS SDK
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0")
    ]
)
