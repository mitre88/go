//
//  GameOverView.swift
//  GoMaster
//
//  Beautiful game over screen with results
//

import SwiftUI

struct GameOverView: View {
    let result: GameResult
    @Binding var isShowing: Bool
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var audioManager: AudioManager

    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0
    @State private var confettiTrigger = 0

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }

            // Main card
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Trophy or result icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: playerWon ? [.yellow, .orange] : [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                        Image(systemName: playerWon ? "trophy.fill" : "flag.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }

                    // Title
                    Text(playerWon ? "¡Victoria!" : "Fin del Juego")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: playerWon ? [.yellow, .orange] : [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    // Result text
                    Text(result.resultText)
                        .font(.title3.weight(.medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.bottom, 30)

                Divider()
                    .padding(.horizontal)

                // Score details
                VStack(spacing: 20) {
                    ScoreRow(
                        label: "Puntuación Final",
                        blackValue: String(format: "%.1f", result.blackScore),
                        whiteValue: String(format: "%.1f", result.whiteScore)
                    )

                    ScoreRow(
                        label: "Territorio",
                        blackValue: "\(result.blackTerritory)",
                        whiteValue: "\(result.whiteTerritory)"
                    )

                    ScoreRow(
                        label: "Capturas",
                        blackValue: "\(result.blackCaptures)",
                        whiteValue: "\(result.whiteCaptures)"
                    )
                }
                .padding(.vertical, 30)

                Divider()
                    .padding(.horizontal)

                // Actions
                HStack(spacing: 16) {
                    Button(action: {
                        audioManager.playButtonSound()
                        dismiss()
                    }) {
                        Text("Cerrar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.gray, .gray.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                    }

                    Button(action: {
                        audioManager.playButtonSound()
                        gameManager.startNewGame(
                            size: gameManager.boardSize,
                            difficulty: gameManager.difficulty
                        )
                        dismiss()
                    }) {
                        Text("Nueva Partida")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 30)
            }
            .frame(maxWidth: 500)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
            .scaleEffect(scale)
            .opacity(opacity)
            .padding(40)

            // Confetti
            if playerWon {
                ConfettiView(trigger: confettiTrigger)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            if playerWon {
                audioManager.playGameOverSound(won: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    confettiTrigger += 1
                }
            } else {
                audioManager.playGameOverSound(won: false)
            }
        }
    }

    private var playerWon: Bool {
        result.winner == .black
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            opacity = 0
            scale = 0.8
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isShowing = false
        }
    }
}

// MARK: - Score Row

struct ScoreRow: View {
    let label: String
    let blackValue: String
    let whiteValue: String

    var body: some View {
        HStack {
            Text(label)
                .font(.body.weight(.medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 20) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 20, height: 20)
                    Text(blackValue)
                        .font(.body.weight(.semibold))
                        .frame(minWidth: 40, alignment: .trailing)
                }

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: 20, height: 20)
                    Text(whiteValue)
                        .font(.body.weight(.semibold))
                        .frame(minWidth: 40, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Confetti

struct ConfettiView: View {
    let trigger: Int

    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(
                    geometry: geometry,
                    delay: Double(index) * 0.02
                )
            }
        }
        .allowsHitTesting(false)
        .id(trigger)
    }
}

struct ConfettiPiece: View {
    let geometry: GeometryProxy
    let delay: Double

    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1

    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]

    var body: some View {
        Rectangle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 10, height: 20)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .position(
                x: geometry.size.width / 2 + xOffset,
                y: yOffset
            )
            .onAppear {
                let startX = CGFloat.random(in: -150...150)
                let endX = startX + CGFloat.random(in: -100...100)

                withAnimation(
                    .easeOut(duration: 3.0)
                    .delay(delay)
                ) {
                    yOffset = geometry.size.height + 50
                    xOffset = endX
                    opacity = 0
                }

                withAnimation(
                    .linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    rotation = 720
                }

                xOffset = startX
            }
    }
}

#Preview {
    GameOverView(
        result: GameResult(
            winner: .black,
            blackScore: 145.0,
            whiteScore: 137.5,
            blackTerritory: 45,
            whiteTerritory: 38,
            blackCaptures: 12,
            whiteCaptures: 8
        ),
        isShowing: .constant(true)
    )
    .environmentObject(GameManager())
    .environmentObject(AudioManager())
}
