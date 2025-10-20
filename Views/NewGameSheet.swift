//
//  NewGameSheet.swift
//  GoMaster
//
//  New game configuration sheet
//

import SwiftUI

struct NewGameSheet: View {
    @EnvironmentObject var gameManager: GameManager
    @Binding var isPresented: Bool

    @State private var selectedSize: Int = 19
    @State private var selectedDifficulty: DifficultyLevel = .expert

    let boardSizes = [9, 13, 19]

    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 0.95, blue: 0.97),
                        Color(red: 0.90, green: 0.92, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        VStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )

                            Text("Nueva Partida")
                                .font(.largeTitle.weight(.bold))

                            Text("Configura tu próximo desafío")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)

                        // Board size selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tamaño del Tablero")
                                .font(.headline)

                            HStack(spacing: 12) {
                                ForEach(boardSizes, id: \.self) { size in
                                    BoardSizeButton(
                                        size: size,
                                        isSelected: selectedSize == size
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedSize = size
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(LiquidGlassCard())
                        .padding(.horizontal)

                        // Difficulty selection
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Dificultad de la IA")
                                .font(.headline)

                            VStack(spacing: 12) {
                                ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                                    DifficultyButton(
                                        difficulty: difficulty,
                                        isSelected: selectedDifficulty == difficulty
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDifficulty = difficulty
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(LiquidGlassCard())
                        .padding(.horizontal)

                        // Start button
                        Button(action: startGame) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.title3)
                                Text("Comenzar Partida")
                                    .font(.headline)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            selectedSize = gameManager.boardSize
            selectedDifficulty = gameManager.difficulty
        }
    }

    private func startGame() {
        gameManager.startNewGame(size: selectedSize, difficulty: selectedDifficulty)
        isPresented = false
    }
}

// MARK: - Board Size Button

struct BoardSizeButton: View {
    let size: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(size)×\(size)")
                    .font(.title2.weight(.bold))
                    .foregroundColor(isSelected ? .white : .primary)

                Text(sizeDescription)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        isSelected ?
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.7), Color.white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.clear : Color.gray.opacity(0.3),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? Color.blue.opacity(0.3) : Color.clear,
                radius: 10,
                x: 0,
                y: 5
            )
        }
    }

    private var sizeDescription: String {
        switch size {
        case 9: return "Rápido"
        case 13: return "Medio"
        case 19: return "Tradicional"
        default: return ""
        }
    }
}

// MARK: - Difficulty Button

struct DifficultyButton: View {
    let difficulty: DifficultyLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue)
                        .font(.body.weight(.semibold))
                        .foregroundColor(isSelected ? .white : .primary)

                    Text(difficultyDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
                }

                Spacer()

                // Strength indicator
                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(
                                index < strengthLevel ?
                                    (isSelected ? Color.white : difficultyColor) :
                                    Color.gray.opacity(0.3)
                            )
                            .frame(width: 8, height: 20)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        isSelected ?
                            LinearGradient(
                                colors: [difficultyColor, difficultyColor.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.7), Color.white.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color.clear : Color.gray.opacity(0.3),
                        lineWidth: 1
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
    }

    private var strengthLevel: Int {
        switch difficulty {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        case .expert: return 4
        case .master: return 5
        }
    }

    private var difficultyColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .orange
        case .expert: return .red
        case .master: return .purple
        }
    }

    private var difficultyDescription: String {
        switch difficulty {
        case .beginner: return "Ideal para comenzar"
        case .intermediate: return "Desafío moderado"
        case .advanced: return "Requiere experiencia"
        case .expert: return "Muy difícil"
        case .master: return "Maestro del Go"
        }
    }
}

#Preview {
    NewGameSheet(isPresented: .constant(true))
        .environmentObject(GameManager())
}
