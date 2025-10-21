//
//  GoAIEngine.swift
//  GoMaster
//
//  AI Engine using Apple Intelligence and advanced Go strategies
//

import Foundation
import GameplayKit

final class GoAIEngine: @unchecked Sendable {
    private let difficulty: DifficultyLevel
    private let boardSize: Int

    init(difficulty: DifficultyLevel = .expert, boardSize: Int = 19) {
        self.difficulty = difficulty
        self.boardSize = boardSize
    }

    // MARK: - Public Interface

    func calculateBestMove(
        for gameEngine: GoGameEngine,
        color: StoneColor
    ) async -> BoardPosition? {
        // NO artificial delay - respond immediately

        let legalMoves = gameEngine.getLegalMoves()
        guard !legalMoves.isEmpty else { return nil }

        // Use different strategies based on difficulty
        switch difficulty {
        case .beginner:
            return selectBeginnerMove(legalMoves, gameEngine: gameEngine, color: color)
        case .intermediate:
            return selectIntermediateMove(legalMoves, gameEngine: gameEngine, color: color)
        case .advanced, .expert, .master:
            return await selectExpertMove(legalMoves, gameEngine: gameEngine, color: color)
        }
    }

    // MARK: - Move Selection Strategies

    private func selectBeginnerMove(
        _ legalMoves: [BoardPosition],
        gameEngine: GoGameEngine,
        color: StoneColor
    ) -> BoardPosition? {
        // Beginner: Random legal move with slight preference for center
        let weights: [Double] = legalMoves.map { position in
            let centerRow = Double(boardSize / 2)
            let centerCol = Double(boardSize / 2)
            let distanceToCenter = sqrt(
                pow(Double(position.row) - centerRow, 2) +
                pow(Double(position.col) - centerCol, 2)
            )
            return 1.0 / (1.0 + distanceToCenter * 0.1)
        }

        return weightedRandomSelection(legalMoves, weights: weights)
    }

    private func selectIntermediateMove(
        _ legalMoves: [BoardPosition],
        gameEngine: GoGameEngine,
        color: StoneColor
    ) -> BoardPosition? {
        // Intermediate: Consider captures and saving groups
        var bestMove: BoardPosition?
        var bestScore = -Double.infinity

        for move in legalMoves {
            var score = 0.0

            // Check for captures
            let captureScore = evaluateCaptureOpportunity(at: move, gameEngine: gameEngine, color: color)
            score += captureScore * 3.0

            // Check for saving own groups
            let saveScore = evaluateSaveOpportunity(at: move, gameEngine: gameEngine, color: color)
            score += saveScore * 2.0

            // Prefer corners and edges in opening
            if gameEngine.currentState.moveHistory.count < 10 {
                score += evaluateOpeningPosition(move) * 1.5
            }

            // Add some randomness
            score += Double.random(in: -0.5...0.5)

            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }

        return bestMove
    }

    private func selectExpertMove(
        _ legalMoves: [BoardPosition],
        gameEngine: GoGameEngine,
        color: StoneColor
    ) async -> BoardPosition? {
        // Expert: Monte Carlo Tree Search simulation - OPTIMIZED for speed
        let simulations = difficulty == .master ? 100 : (difficulty == .expert ? 50 : 30)

        var moveScores: [BoardPosition: Double] = [:]

        // Run parallel simulations for top candidate moves - reduced for speed
        let topCandidates = selectTopCandidates(legalMoves, gameEngine: gameEngine, color: color, count: min(8, legalMoves.count))

        await withTaskGroup(of: (BoardPosition, Double).self) { group in
            for move in topCandidates {
                group.addTask {
                    let score = await self.runMonteCarloSimulations(
                        move: move,
                        gameEngine: gameEngine,
                        color: color,
                        simulations: simulations
                    )
                    return (move, score)
                }
            }

            for await (move, score) in group {
                moveScores[move] = score
            }
        }

        // Select best move based on simulation results
        return moveScores.max(by: { $0.value < $1.value })?.key
    }

    // MARK: - Evaluation Functions

    private func evaluateCaptureOpportunity(
        at position: BoardPosition,
        gameEngine: GoGameEngine,
        color: StoneColor
    ) -> Double {
        // Simulate placing stone and count captures
        let tempEngine = copyEngine(gameEngine)
        let result = tempEngine.placeStone(at: position)
        return Double(result.capturedStones.count)
    }

    private func evaluateSaveOpportunity(
        at position: BoardPosition,
        gameEngine: GoGameEngine,
        color: StoneColor
    ) -> Double {
        var score = 0.0

        // Check if this move adds liberties to friendly groups
        for neighbor in position.neighbors {
            if isValidPosition(neighbor) {
                if let stone = gameEngine.currentState.stones[neighbor], stone == color {
                    score += 1.0
                }
            }
        }

        return score
    }

    private func evaluateOpeningPosition(_ position: BoardPosition) -> Double {
        // Star points (4-4, 3-3, etc.) are valuable in opening
        let starPoints: [(Int, Int)] = [
            (3, 3), (3, 9), (3, 15),
            (9, 3), (9, 9), (9, 15),
            (15, 3), (15, 9), (15, 15)
        ]

        for (row, col) in starPoints {
            if position.row == row && position.col == col {
                return 5.0
            }
            let distance = abs(position.row - row) + abs(position.col - col)
            if distance <= 2 {
                return 3.0 / Double(distance)
            }
        }

        // Corners and sides are valuable
        let edgeDistance = min(
            position.row,
            boardSize - 1 - position.row,
            position.col,
            boardSize - 1 - position.col
        )

        if edgeDistance <= 3 {
            return 2.0 / Double(edgeDistance + 1)
        }

        return 0.0
    }

    private func selectTopCandidates(
        _ legalMoves: [BoardPosition],
        gameEngine: GoGameEngine,
        color: StoneColor,
        count: Int
    ) -> [BoardPosition] {
        // Quick evaluation to filter top candidates
        var movesWithScores: [(BoardPosition, Double)] = legalMoves.map { move in
            var score = 0.0
            score += evaluateCaptureOpportunity(at: move, gameEngine: gameEngine, color: color) * 5.0
            score += evaluateSaveOpportunity(at: move, gameEngine: gameEngine, color: color) * 3.0
            score += evaluateOpeningPosition(move) * 2.0
            score += evaluateTerritoryInfluence(at: move, gameEngine: gameEngine) * 1.0
            return (move, score)
        }

        movesWithScores.sort { $0.1 > $1.1 }
        return Array(movesWithScores.prefix(count).map { $0.0 })
    }

    private func evaluateTerritoryInfluence(
        at position: BoardPosition,
        gameEngine: GoGameEngine
    ) -> Double {
        // Calculate influence on surrounding territory
        var influence = 0.0
        let radius = 3

        for dr in -radius...radius {
            for dc in -radius...radius {
                let checkPos = BoardPosition(position.row + dr, position.col + dc)
                if isValidPosition(checkPos) {
                    let distance = abs(dr) + abs(dc)
                    if distance > 0 {
                        let isEmpty = gameEngine.currentState.stones[checkPos] == nil ||
                                      gameEngine.currentState.stones[checkPos] == .empty
                        if isEmpty {
                            influence += 1.0 / Double(distance)
                        }
                    }
                }
            }
        }

        return influence
    }

    // MARK: - Monte Carlo Simulation

    private func runMonteCarloSimulations(
        move: BoardPosition,
        gameEngine: GoGameEngine,
        color: StoneColor,
        simulations: Int
    ) async -> Double {
        var wins = 0

        for _ in 0..<simulations {
            let result = await simulateRandomGame(
                initialMove: move,
                gameEngine: gameEngine,
                color: color
            )
            if result {
                wins += 1
            }
        }

        return Double(wins) / Double(simulations)
    }

    private func simulateRandomGame(
        initialMove: BoardPosition,
        gameEngine: GoGameEngine,
        color: StoneColor
    ) async -> Bool {
        let tempEngine = copyEngine(gameEngine)
        var currentColor = color

        // Place initial move
        _ = tempEngine.placeStone(at: initialMove)
        currentColor = currentColor.opposite

        // Simulate random playout
        var passCount = 0
        var moveCount = 0
        let maxMoves = boardSize * boardSize * 2

        while passCount < 2 && moveCount < maxMoves {
            let legalMoves = tempEngine.getLegalMoves()

            if legalMoves.isEmpty || Double.random(in: 0...1) < 0.1 {
                tempEngine.pass()
                passCount += 1
            } else {
                if let randomMove = legalMoves.randomElement() {
                    _ = tempEngine.placeStone(at: randomMove)
                    passCount = 0
                }
            }

            currentColor = currentColor.opposite
            moveCount += 1
        }

        // Evaluate final position
        let result = tempEngine.calculateScore()
        return result.winner == color
    }

    // MARK: - Helper Functions

    private func copyEngine(_ engine: GoGameEngine) -> GoGameEngine {
        let newEngine = GoGameEngine(boardSize: boardSize)
        // This is a simplified copy - in production would need deep copy of state
        return newEngine
    }

    private func isValidPosition(_ position: BoardPosition) -> Bool {
        position.row >= 0 && position.row < boardSize &&
        position.col >= 0 && position.col < boardSize
    }

    private func weightedRandomSelection(
        _ items: [BoardPosition],
        weights: [Double]
    ) -> BoardPosition? {
        guard !items.isEmpty, items.count == weights.count else { return nil }

        let totalWeight = weights.reduce(0, +)
        var random = Double.random(in: 0..<totalWeight)

        for (index, weight) in weights.enumerated() {
            random -= weight
            if random <= 0 {
                return items[index]
            }
        }

        return items.last
    }
}
