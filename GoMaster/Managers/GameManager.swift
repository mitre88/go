//
//  GameManager.swift
//  GoMaster
//
//  Central game state management
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class GameManager: ObservableObject {
    @Published var gameEngine: GoGameEngine
    @Published var aiEngine: GoAIEngine
    @Published var gameState: GameState
    @Published var isAIThinking = false
    @Published var lastMove: BoardPosition?
    @Published var capturedStones: [BoardPosition] = []
    @Published var gameResult: GameResult?
    @Published var showGameOver = false
    @Published var difficulty: DifficultyLevel = .expert
    @Published var boardSize: Int = 19

    @Published var scores: [PlayerScore] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        let engine = GoGameEngine(boardSize: 19)
        self.gameEngine = engine
        self.aiEngine = GoAIEngine(difficulty: .expert, boardSize: 19)
        self.gameState = engine.currentState
        loadScores()
    }

    // MARK: - Game Actions

    func startNewGame(size: Int = 19, difficulty: DifficultyLevel = .expert) {
        self.boardSize = size
        self.difficulty = difficulty
        self.gameEngine = GoGameEngine(boardSize: size)
        self.aiEngine = GoAIEngine(difficulty: difficulty, boardSize: size)
        self.gameState = gameEngine.currentState
        self.lastMove = nil
        self.capturedStones = []
        self.gameResult = nil
        self.showGameOver = false
        self.isAIThinking = false
    }

    func placeStone(at position: BoardPosition) async {
        guard !isAIThinking else { return }

        let result = gameEngine.placeStone(at: position)

        if result.success {
            lastMove = position
            capturedStones = result.capturedStones
            gameState = gameEngine.currentState

            // Check for game over
            if gameEngine.isGameOver() {
                endGame()
                return
            }

            // AI's turn
            await playAIMove()
        }
    }

    func pass() async {
        guard !isAIThinking else { return }

        gameEngine.pass()
        gameState = gameEngine.currentState

        if gameEngine.isGameOver() {
            endGame()
            return
        }

        await playAIMove()
    }

    func undoMove() {
        guard gameEngine.canUndo() else { return }

        // Undo player move
        gameEngine.undoLastMove()

        // Undo AI move if present
        if gameEngine.canUndo() {
            gameEngine.undoLastMove()
        }

        gameState = gameEngine.currentState
        lastMove = gameState.moveHistory.last?.position
    }

    func resign() {
        let winner = gameState.currentPlayer.opposite
        gameResult = GameResult(
            winner: winner,
            blackScore: 0,
            whiteScore: 0,
            blackTerritory: 0,
            whiteTerritory: 0,
            blackCaptures: gameState.capturedBlack,
            whiteCaptures: gameState.capturedWhite
        )
        showGameOver = true
    }

    // MARK: - AI

    private func playAIMove() async {
        isAIThinking = true

        // Small delay for UI feedback
        try? await Task.sleep(nanoseconds: 300_000_000)

        let currentAI = aiEngine
        let currentEngine = gameEngine
        let currentPlayer = gameState.currentPlayer

        let aiMove = await currentAI.calculateBestMove(
            for: currentEngine,
            color: currentPlayer
        )

        if let move = aiMove {
            let result = gameEngine.placeStone(at: move)
            lastMove = move
            capturedStones = result.capturedStones
            gameState = gameEngine.currentState
        } else {
            // AI passes
            gameEngine.pass()
            gameState = gameEngine.currentState
        }

        isAIThinking = false

        if gameEngine.isGameOver() {
            endGame()
        }
    }

    // MARK: - Game End

    private func endGame() {
        gameResult = gameEngine.calculateScore()
        showGameOver = true

        // Save score
        if let result = gameResult {
            let playerScore = PlayerScore(
                date: Date(),
                playerColor: .black,
                score: result.blackScore,
                difficulty: difficulty,
                won: result.winner == .black
            )
            scores.insert(playerScore, at: 0)
            saveScores()
        }
    }

    // MARK: - Persistence

    private func loadScores() {
        if let data = UserDefaults.standard.data(forKey: "GoMasterScores"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            scores = decoded
        }
    }

    private func saveScores() {
        if let encoded = try? JSONEncoder().encode(scores) {
            UserDefaults.standard.set(encoded, forKey: "GoMasterScores")
        }
    }

    func clearScores() {
        scores = []
        UserDefaults.standard.removeObject(forKey: "GoMasterScores")
    }
}
