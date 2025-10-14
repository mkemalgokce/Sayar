#!/usr/bin/swift

import AppKit
import Foundation

struct IconConfig {
    let name: String
    let primaryColor: NSColor
    let secondaryColor: NSColor
    let badge: String
    let badgeColor: NSColor
}

func generateAppIcon(config: IconConfig, size: CGSize, outputPath: String) {
    let image = NSImage(size: size)

    image.lockFocus()

    // Create gradient background
    let gradient = NSGradient(colors: [config.primaryColor, config.secondaryColor])

    let rect = NSRect(origin: .zero, size: size)
    gradient?.draw(in: rect, angle: 135)

    // Add rounded rectangle overlay for depth
    let overlayRect = rect.insetBy(dx: size.width * 0.15, dy: size.height * 0.15)
    let overlayPath = NSBezierPath(roundedRect: overlayRect, xRadius: 40, yRadius: 40)
    NSColor.white.withAlphaComponent(0.2).setFill()
    overlayPath.fill()

    // Draw app initial "S" for Sayar
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center

    let fontSize = size.width * 0.45
    let attributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: fontSize, weight: .bold),
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle
    ]

    let text = "S"
    let textSize = text.size(withAttributes: attributes)
    let textRect = NSRect(
        x: (size.width - textSize.width) / 2,
        y: (size.height - textSize.height) / 2 + size.height * 0.05,
        width: textSize.width,
        height: textSize.height
    )

    text.draw(in: textRect, withAttributes: attributes)

    // Add environment badge at bottom
    let badgeFontSize = size.width * 0.15
    let badgeAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: badgeFontSize, weight: .heavy),
        .foregroundColor: NSColor.white,
        .paragraphStyle: paragraphStyle
    ]

    let badge = config.badge
    let badgeSize = badge.size(withAttributes: badgeAttributes)

    // Badge background
    let badgeBackgroundRect = NSRect(
        x: 0,
        y: 0,
        width: size.width,
        height: size.height * 0.25
    )
    config.badgeColor.setFill()
    NSBezierPath(rect: badgeBackgroundRect).fill()

    // Badge text
    let badgeRect = NSRect(
        x: (size.width - badgeSize.width) / 2,
        y: (badgeBackgroundRect.height - badgeSize.height) / 2,
        width: badgeSize.width,
        height: badgeSize.height
    )
    badge.draw(in: badgeRect, withAttributes: badgeAttributes)

    image.unlockFocus()

    // Save as PNG
    guard let tiffData = image.tiffRepresentation,
          let bitmapImage = NSBitmapImageRep(data: tiffData),
          let pngData = bitmapImage.representation(using: .png, properties: [:])
    else {
        print("❌ Failed to generate PNG data for \(config.name)")
        return
    }

    let url = URL(fileURLWithPath: outputPath)
    try? pngData.write(to: url)
    print("✅ Generated: \(config.name)")
}

func writeContentsJSON(path: String) {
    let json = """
    {
      "images" : [
        {
          "filename" : "AppIcon-1024.png",
          "idiom" : "universal",
          "platform" : "ios",
          "size" : "1024x1024"
        }
      ],
      "info" : {
        "author" : "xcode",
        "version" : 1
      }
    }
    """

    try? json.write(toFile: path, atomically: true, encoding: .utf8)
}

// Icon configurations for each environment
let configs = [
    IconConfig(
        name: "Dev",
        primaryColor: NSColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0), // Orange
        secondaryColor: NSColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0), // Red
        badge: "DEV",
        badgeColor: NSColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.9)
    ),
    IconConfig(
        name: "UAT",
        primaryColor: NSColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), // Yellow
        secondaryColor: NSColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0), // Amber
        badge: "UAT",
        badgeColor: NSColor(red: 0.8, green: 0.4, blue: 0.0, alpha: 0.9)
    ),
    IconConfig(
        name: "Prod",
        primaryColor: NSColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0), // Blue
        secondaryColor: NSColor(red: 0.4, green: 0.3, blue: 0.9, alpha: 1.0), // Purple
        badge: "",
        badgeColor: NSColor.clear
    )
]

// Generate icons
let size = CGSize(width: 1024, height: 1024)

for config in configs {
    let outputPath = "App/Resources/Assets.xcassets/AppIcon-\(config.name).appiconset/AppIcon-1024.png"
    generateAppIcon(config: config, size: size, outputPath: outputPath)

    let contentsPath = "App/Resources/Assets.xcassets/AppIcon-\(config.name).appiconset/Contents.json"
    writeContentsJSON(path: contentsPath)
}

print("🎉 All environment app icons generated successfully!")
