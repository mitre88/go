//
//  IntroView.swift
//  GoMaster
//
//  Animated intro with Liquid Glass effect
//

import SwiftUI

struct IntroView: View {
    @Binding var isShowing: Bool
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var particleOffset: CGFloat = 0
    @State private var gradientRotation: Double = 0

    var body: some View {
        ZStack {
            // Animated gradient background
            AnimatedGradientBackground()

            // Floating particles
            FloatingParticles(offset: particleOffset)

            // Main content
            VStack(spacing: 40) {
                Spacer()

                // Logo with liquid glass effect
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.blue.opacity(0.6),
                                    Color.purple.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .scaleEffect(pulseScale)
                        .blur(radius: 30)

                    // Main logo
                    GoLogoView()
                        .frame(width: 200, height: 200)
                        .scaleEffect(scale)
                        .rotation3DEffect(
                            .degrees(rotation),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .overlay(
                            LiquidGlassOverlay()
                        )
                }

                // Title with animated gradient
                VStack(spacing: 12) {
                    Text("GoMaster")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(opacity)

                    Text("El Arte Milenario del Go")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.secondary)
                        .opacity(opacity * 0.8)
                }

                Spacer()

                // Loading indicator
                LoadingDotsView()
                    .opacity(opacity)

                Spacer()
                    .frame(height: 60)
            }
            .padding()
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Scale and fade in
        withAnimation(.spring(response: 1.2, dampingFraction: 0.6, blendDuration: 0)) {
            scale = 1.0
            opacity = 1.0
        }

        // Rotation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }

        // Pulse effect
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }

        // Particle movement
        withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
            particleOffset = 1000
        }

        // Auto dismiss after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                opacity = 0
                scale = 1.5
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isShowing = false
            }
        }
    }
}

// MARK: - Subviews

struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.45),
                Color(red: 0.3, green: 0.15, blue: 0.5),
                Color(red: 0.15, green: 0.3, blue: 0.45)
            ],
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct FloatingParticles: View {
    let offset: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(
                        Color.white.opacity(Double.random(in: 0.1...0.3))
                    )
                    .frame(
                        width: CGFloat.random(in: 4...12),
                        height: CGFloat.random(in: 4...12)
                    )
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat(index) * 50 + offset
                    )
            }
        }
    }
}

struct GoLogoView: View {
    var body: some View {
        ZStack {
            // Board background
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.7, blue: 0.45),
                            Color(red: 0.75, green: 0.6, blue: 0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)

            // Grid lines
            Canvas { context, size in
                let spacing = size.width / 5
                for i in 1..<5 {
                    let offset = spacing * CGFloat(i)

                    // Vertical lines
                    var verticalPath = Path()
                    verticalPath.move(to: CGPoint(x: offset, y: spacing))
                    verticalPath.addLine(to: CGPoint(x: offset, y: size.height - spacing))
                    context.stroke(verticalPath, with: .color(.black.opacity(0.3)), lineWidth: 1)

                    // Horizontal lines
                    var horizontalPath = Path()
                    horizontalPath.move(to: CGPoint(x: spacing, y: offset))
                    horizontalPath.addLine(to: CGPoint(x: size.width - spacing, y: offset))
                    context.stroke(horizontalPath, with: .color(.black.opacity(0.3)), lineWidth: 1)
                }
            }
            .padding(20)

            // Stones
            HStack(spacing: -30) {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white, .gray.opacity(0.8)],
                            center: .topLeading,
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 2, y: 2)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.gray.opacity(0.3), .black],
                            center: .topLeading,
                            startRadius: 5,
                            endRadius: 40
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 2, y: 2)
            }
        }
    }
}

struct LiquidGlassOverlay: View {
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(0.0),
                        .white.opacity(0.3),
                        .white.opacity(0.0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .offset(x: shimmerOffset)
            .blur(radius: 10)
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    shimmerOffset = 400
                }
            }
    }
}

struct LoadingDotsView: View {
    @State private var animatingDot = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 10, height: 10)
                    .scaleEffect(animatingDot == index ? 1.5 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animatingDot
                    )
            }
        }
        .onAppear {
            animatingDot = 0
        }
    }
}

#Preview {
    IntroView(isShowing: .constant(true))
}
