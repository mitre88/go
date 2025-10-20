//
//  AppIcon-Generator.swift
//  GoMaster
//
//  Generate all required app icons for App Store
//

import Foundation
import SwiftUI
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

@available(macOS 10.15, *)
struct AppIconGenerator {
    // Icon sizes required for App Store submission
    static let requiredSizes: [(size: CGFloat, name: String)] = [
        // iPhone
        (20, "Icon-20"),
        (29, "Icon-29"),
        (40, "Icon-40"),
        (60, "Icon-60"),
        (58, "Icon-58"),
        (80, "Icon-80"),
        (87, "Icon-87"),
        (120, "Icon-120"),
        (180, "Icon-180"),

        // iPad
        (20, "Icon-iPad-20"),
        (29, "Icon-iPad-29"),
        (40, "Icon-iPad-40"),
        (76, "Icon-iPad-76"),
        (152, "Icon-iPad-152"),
        (167, "Icon-iPad-167"),

        // App Store
        (1024, "Icon-AppStore-1024"),

        // Additional sizes
        (512, "Icon-512"),
        (256, "Icon-256"),
        (128, "Icon-128"),
        (64, "Icon-64"),
        (32, "Icon-32"),
        (16, "Icon-16")
    ]

    static func generateAllIcons(outputDirectory: String) {
        let iconView = AppIconView()

        for (size, name) in requiredSizes {
            let image = renderIcon(view: iconView, size: size)
            saveImage(image, name: name, directory: outputDirectory)
            print("Generated: \(name)@\(size)x\(size)")
        }

        generateContentsJSON(outputDirectory: outputDirectory)
        print("\nAll icons generated successfully!")
        print("Icons saved to: \(outputDirectory)")
    }

    private static func renderIcon(view: AppIconView, size: CGFloat) -> CGImage {
        let renderer = ImageRenderer(content: view.frame(width: size, height: size))
        renderer.scale = 1.0

        guard let cgImage = renderer.cgImage else {
            fatalError("Failed to render icon")
        }

        return cgImage
    }

    private static func saveImage(_ image: CGImage, name: String, directory: String) {
        let fileURL = URL(fileURLWithPath: "\(directory)/\(name).png")

        guard let destination = CGImageDestinationCreateWithURL(
            fileURL as CFURL,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else {
            print("Failed to create destination for \(name)")
            return
        }

        CGImageDestinationAddImage(destination, image, nil)

        if !CGImageDestinationFinalize(destination) {
            print("Failed to save \(name)")
        }
    }

    private static func generateContentsJSON(outputDirectory: String) {
        let contents = """
        {
          "images" : [
            {
              "filename" : "Icon-40.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "20x20"
            },
            {
              "filename" : "Icon-60.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "20x20"
            },
            {
              "filename" : "Icon-58.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "29x29"
            },
            {
              "filename" : "Icon-87.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "29x29"
            },
            {
              "filename" : "Icon-80.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "40x40"
            },
            {
              "filename" : "Icon-120.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "40x40"
            },
            {
              "filename" : "Icon-120.png",
              "idiom" : "iphone",
              "scale" : "2x",
              "size" : "60x60"
            },
            {
              "filename" : "Icon-180.png",
              "idiom" : "iphone",
              "scale" : "3x",
              "size" : "60x60"
            },
            {
              "filename" : "Icon-iPad-20.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "20x20"
            },
            {
              "filename" : "Icon-iPad-40.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "20x20"
            },
            {
              "filename" : "Icon-iPad-29.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "29x29"
            },
            {
              "filename" : "Icon-58.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "29x29"
            },
            {
              "filename" : "Icon-iPad-40.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "40x40"
            },
            {
              "filename" : "Icon-80.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "40x40"
            },
            {
              "filename" : "Icon-iPad-76.png",
              "idiom" : "ipad",
              "scale" : "1x",
              "size" : "76x76"
            },
            {
              "filename" : "Icon-iPad-152.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "76x76"
            },
            {
              "filename" : "Icon-iPad-167.png",
              "idiom" : "ipad",
              "scale" : "2x",
              "size" : "83.5x83.5"
            },
            {
              "filename" : "Icon-AppStore-1024.png",
              "idiom" : "ios-marketing",
              "scale" : "1x",
              "size" : "1024x1024"
            }
          ],
          "info" : {
            "author" : "xcode",
            "version" : 1
          }
        }
        """

        let fileURL = URL(fileURLWithPath: "\(outputDirectory)/Contents.json")
        try? contents.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}

// MARK: - App Icon Design

struct AppIconView: View {
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.6),
                    Color(red: 0.3, green: 0.2, blue: 0.7),
                    Color(red: 0.5, green: 0.1, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Go board pattern
            VStack(spacing: 2) {
                ForEach(0..<5) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<5) { col in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 18, height: 18)
                        }
                    }
                }
            }
            .blur(radius: 1)

            // Central design
            ZStack {
                // Glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)

                // Black stone
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.gray.opacity(0.5),
                                Color.black,
                                Color.black
                            ],
                            center: .init(x: 0.35, y: 0.35),
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .offset(x: -20, y: -20)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 3, y: 3)

                // White stone
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white,
                                Color.white,
                                Color.gray.opacity(0.4)
                            ],
                            center: .init(x: 0.35, y: 0.35),
                            startRadius: 0,
                            endRadius: 35
                        )
                    )
                    .frame(width: 70, height: 70)
                    .offset(x: 20, y: 20)
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 3, y: 3)
            }

            // Subtle border
            RoundedRectangle(cornerRadius: 0)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Main execution

#if os(macOS)
if #available(macOS 10.15, *) {
    let args = CommandLine.arguments
    let outputDir = args.count > 1 ? args[1] : "./AppIcons"

    // Create directory if it doesn't exist
    try? FileManager.default.createDirectory(
        atPath: outputDir,
        withIntermediateDirectories: true
    )

    AppIconGenerator.generateAllIcons(outputDirectory: outputDir)
}
#endif
