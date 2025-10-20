//
//  ContentView.swift
//  GoMaster
//
//  Main game view with modern UI
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var audioManager: AudioManager
    @State private var showSettings = false
    @State private var showScores = false
    @State private var showNewGameSheet = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Game View
            GameView()
                .environmentObject(gameManager)
                .environmentObject(audioManager)
                .tabItem {
                    Label("Juego", systemImage: "circle.grid.3x3.fill")
                }
                .tag(0)

            // Scores View
            ScoresView()
                .environmentObject(gameManager)
                .tabItem {
                    Label("Marcadores", systemImage: "chart.bar.fill")
                }
                .tag(1)

            // Settings View
            SettingsView()
                .environmentObject(gameManager)
                .environmentObject(audioManager)
                .tabItem {
                    Label("Ajustes", systemImage: "gear")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

struct GameView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var audioManager: AudioManager
    @State private var showNewGameSheet = false
    @State private var selectedIntersection: BoardPosition?

    var body: some View {
        ZStack {
            // Background with subtle gradient
            LinearGradient(
                colors: [
                    Color(red: 0.95, green: 0.95, blue: 0.97),
                    Color(red: 0.90, green: 0.92, blue: 0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar with scores
                TopBarView()
                    .environmentObject(gameManager)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Board
                GeometryReader { geometry in
                    GoBoardView(
                        gameState: gameManager.gameState,
                        lastMove: gameManager.lastMove,
                        onIntersectionTapped: { position in
                            Task {
                                audioManager.playStoneSound()
                                await gameManager.placeStone(at: position)
                            }
                        }
                    )
                    .frame(
                        width: min(geometry.size.width, geometry.size.height) - 40,
                        height: min(geometry.size.width, geometry.size.height) - 40
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Bottom controls
                BottomControlsView(showNewGameSheet: $showNewGameSheet)
                    .environmentObject(gameManager)
                    .environmentObject(audioManager)
                    .padding()
            }

            // AI thinking indicator
            if gameManager.isAIThinking {
                AIThinkingOverlay()
            }

            // Game over sheet
            if gameManager.showGameOver, let result = gameManager.gameResult {
                GameOverView(result: result, isShowing: $gameManager.showGameOver)
                    .environmentObject(gameManager)
                    .environmentObject(audioManager)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .sheet(isPresented: $showNewGameSheet) {
            NewGameSheet(isPresented: $showNewGameSheet)
                .environmentObject(gameManager)
        }
    }
}

// MARK: - Top Bar

struct TopBarView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        HStack(spacing: 20) {
            // Black score
            PlayerScoreCard(
                color: .black,
                displayName: "Tú",
                captures: gameManager.gameState.capturedBlack,
                isCurrentPlayer: gameManager.gameState.currentPlayer == .black
            )

            Spacer()

            // Turn indicator
            VStack(spacing: 4) {
                Text("Turno")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Circle()
                    .fill(gameManager.gameState.currentPlayer.displayColor)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }

            Spacer()

            // White score (AI)
            PlayerScoreCard(
                color: .white,
                displayName: "IA",
                captures: gameManager.gameState.capturedWhite,
                isCurrentPlayer: gameManager.gameState.currentPlayer == .white
            )
        }
        .padding()
        .background(
            LiquidGlassCard()
        )
    }
}

struct PlayerScoreCard: View {
    let color: StoneColor
    let displayName: String
    let captures: Int
    let isCurrentPlayer: Bool

    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color.displayColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Circle()
                        .stroke(isCurrentPlayer ? Color.blue : Color.clear, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            Text(displayName)
                .font(.subheadline.weight(.semibold))

            HStack(spacing: 4) {
                Image(systemName: "circle.fill")
                    .font(.caption2)
                Text("\(captures)")
                    .font(.caption.weight(.medium))
            }
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - Bottom Controls

struct BottomControlsView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var audioManager: AudioManager
    @Binding var showNewGameSheet: Bool

    var body: some View {
        HStack(spacing: 16) {
            // New Game
            ControlButton(
                icon: "plus.circle.fill",
                label: "Nuevo",
                color: .green
            ) {
                audioManager.playButtonSound()
                showNewGameSheet = true
            }

            // Undo
            ControlButton(
                icon: "arrow.uturn.backward.circle.fill",
                label: "Deshacer",
                color: .orange,
                disabled: !gameManager.gameEngine.canUndo()
            ) {
                audioManager.playButtonSound()
                gameManager.undoMove()
            }

            // Pass
            ControlButton(
                icon: "forward.circle.fill",
                label: "Pasar",
                color: .blue
            ) {
                audioManager.playPassSound()
                Task {
                    await gameManager.pass()
                }
            }

            // Resign
            ControlButton(
                icon: "flag.circle.fill",
                label: "Rendirse",
                color: .red
            ) {
                audioManager.playButtonSound()
                gameManager.resign()
            }
        }
        .padding()
        .background(
            LiquidGlassCard()
        )
    }
}

struct ControlButton: View {
    let icon: String
    let label: String
    let color: Color
    var disabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundStyle(
                        LinearGradient(
                            colors: disabled ? [.gray] : [color, color.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(label)
                    .font(.caption2.weight(.medium))
                    .foregroundColor(disabled ? .gray : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .disabled(disabled)
    }
}

// MARK: - AI Thinking Overlay

struct AIThinkingOverlay: View {
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 60, height: 60)

                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotation))
                }

                Text("IA pensando...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

// MARK: - Liquid Glass Card

struct LiquidGlassCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.2),
                                .white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ContentView()
        .environmentObject(GameManager())
        .environmentObject(AudioManager())
}
