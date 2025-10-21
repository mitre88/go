//
//  GoGameEngine.swift
//  GoMaster
//
//  Core game logic with strict Go rules implementation
//

import Foundation

final class GoGameEngine: @unchecked Sendable {
    private var state: GameState

    init(boardSize: Int = 19) {
        self.state = GameState(boardSize: boardSize)
    }

    // MARK: - Public Interface

    var currentState: GameState {
        state
    }

    func resetGame(boardSize: Int = 19) {
        state.reset(boardSize: boardSize)
    }

    /// Attempts to place a stone at the given position
    /// Returns true if the move was legal and executed
    func placeStone(at position: BoardPosition) -> (success: Bool, capturedStones: [BoardPosition]) {
        // Check if position is valid
        guard isValidPosition(position) else {
            return (false, [])
        }

        // Check if position is empty
        guard state.stones[position] == nil || state.stones[position] == .empty else {
            return (false, [])
        }

        // Check Ko rule
        if let koPos = state.koPosition, koPos == position {
            return (false, [])
        }

        // Temporarily place the stone
        state.stones[position] = state.currentPlayer

        // Check for captured opponent groups
        let capturedStones = captureOpponentGroups(around: position)

        // Check if placing this stone creates a suicide move (illegal unless it captures)
        if capturedStones.isEmpty {
            let group = findGroup(at: position)
            if group.isDead {
                // Remove the stone (illegal move)
                state.stones[position] = .empty
                return (false, [])
            }
        }

        // Update Ko position (only if exactly one stone was captured)
        if capturedStones.count == 1 {
            state.koPosition = capturedStones[0]
        } else {
            state.koPosition = nil
        }

        // Update captured count
        if state.currentPlayer == .black {
            state.capturedWhite += capturedStones.count
        } else {
            state.capturedBlack += capturedStones.count
        }

        // Record the move
        let move = Move(
            position: position,
            color: state.currentPlayer,
            capturedStones: capturedStones,
            timestamp: Date()
        )
        state.moveHistory.append(move)
        state.passCount = 0

        // Switch player
        state.currentPlayer = state.currentPlayer.opposite

        return (true, capturedStones)
    }

    func pass() {
        let move = Move(
            position: nil,
            color: state.currentPlayer,
            capturedStones: [],
            timestamp: Date()
        )
        state.moveHistory.append(move)
        state.passCount += 1
        state.currentPlayer = state.currentPlayer.opposite
    }

    func isGameOver() -> Bool {
        state.passCount >= 2
    }

    /// Calculate final score using area scoring (Chinese rules)
    func calculateScore(komi: Double = 7.5) -> GameResult {
        var blackTerritory = 0
        var whiteTerritory = 0

        // Calculate territory for each empty intersection
        for row in 0..<state.boardSize {
            for col in 0..<state.boardSize {
                let pos = BoardPosition(row, col)
                if state.stones[pos] == nil || state.stones[pos] == .empty {
                    let owner = determineTerritoryOwner(at: pos)
                    if owner == .black {
                        blackTerritory += 1
                    } else if owner == .white {
                        whiteTerritory += 1
                    }
                }
            }
        }

        // Count stones on board
        let blackStones = state.stones.values.filter { $0 == .black }.count
        let whiteStones = state.stones.values.filter { $0 == .white }.count

        // Area scoring: stones + territory
        let blackScore = Double(blackStones + blackTerritory)
        let whiteScore = Double(whiteStones + whiteTerritory) + komi

        state.territoryBlack = blackTerritory
        state.territoryWhite = whiteTerritory

        let winner: StoneColor? = {
            if blackScore > whiteScore {
                return .black
            } else if whiteScore > blackScore {
                return .white
            } else {
                return nil
            }
        }()

        return GameResult(
            winner: winner,
            blackScore: blackScore,
            whiteScore: whiteScore,
            blackTerritory: blackTerritory,
            whiteTerritory: whiteTerritory,
            blackCaptures: state.capturedBlack,
            whiteCaptures: state.capturedWhite
        )
    }

    // MARK: - Legal Moves

    func getLegalMoves() -> [BoardPosition] {
        var legalMoves: [BoardPosition] = []

        for row in 0..<state.boardSize {
            for col in 0..<state.boardSize {
                let pos = BoardPosition(row, col)
                if isLegalMove(at: pos) {
                    legalMoves.append(pos)
                }
            }
        }

        return legalMoves
    }

    func isLegalMove(at position: BoardPosition) -> Bool {
        // Check if position is valid
        guard isValidPosition(position) else { return false }

        // Check if position is empty
        guard state.stones[position] == nil || state.stones[position] == .empty else {
            return false
        }

        // Check Ko rule
        if let koPos = state.koPosition, koPos == position {
            return false
        }

        // Temporarily place stone
        let originalStone = state.stones[position]
        state.stones[position] = state.currentPlayer

        // Check if this would capture opponent stones
        let wouldCapture = !captureOpponentGroups(around: position, simulate: true).isEmpty

        // Check if this creates suicide (illegal unless capturing)
        let group = findGroup(at: position)
        let isSuicide = group.isDead && !wouldCapture

        // Restore original state
        state.stones[position] = originalStone

        return !isSuicide
    }

    // MARK: - Private Helpers

    private func isValidPosition(_ position: BoardPosition) -> Bool {
        position.row >= 0 && position.row < state.boardSize &&
        position.col >= 0 && position.col < state.boardSize
    }

    private func captureOpponentGroups(around position: BoardPosition, simulate: Bool = false) -> [BoardPosition] {
        let opponentColor = state.currentPlayer.opposite
        var capturedStones: [BoardPosition] = []

        for neighbor in position.neighbors where isValidPosition(neighbor) {
            if state.stones[neighbor] == opponentColor {
                let group = findGroup(at: neighbor)
                if group.isDead {
                    capturedStones.append(contentsOf: group.stones)
                }
            }
        }

        // Actually remove the captured stones if not simulating
        if !simulate {
            for pos in capturedStones {
                state.stones[pos] = .empty
            }
        }

        return capturedStones
    }

    private func findGroup(at position: BoardPosition) -> Group {
        guard let color = state.stones[position], color != .empty else {
            return Group(stones: [], color: .empty, liberties: [])
        }

        var visited = Set<BoardPosition>()
        var stones = Set<BoardPosition>()
        var liberties = Set<BoardPosition>()

        func explore(_ pos: BoardPosition) {
            guard isValidPosition(pos), !visited.contains(pos) else { return }
            visited.insert(pos)

            let stoneColor = state.stones[pos]

            if stoneColor == nil || stoneColor == .empty {
                liberties.insert(pos)
            } else if stoneColor == color {
                stones.insert(pos)
                for neighbor in pos.neighbors {
                    explore(neighbor)
                }
            }
        }

        explore(position)
        return Group(stones: stones, color: color, liberties: liberties)
    }

    private func determineTerritoryOwner(at position: BoardPosition) -> StoneColor {
        var visited = Set<BoardPosition>()
        var touchesBlack = false
        var touchesWhite = false

        func floodFill(_ pos: BoardPosition) {
            guard isValidPosition(pos), !visited.contains(pos) else { return }
            visited.insert(pos)

            let stone = state.stones[pos]

            if stone == .black {
                touchesBlack = true
            } else if stone == .white {
                touchesWhite = true
            } else {
                for neighbor in pos.neighbors {
                    floodFill(neighbor)
                }
            }
        }

        floodFill(position)

        // Territory belongs to a color only if it touches that color exclusively
        if touchesBlack && !touchesWhite {
            return .black
        } else if touchesWhite && !touchesBlack {
            return .white
        } else {
            return .empty // Neutral territory
        }
    }

    // MARK: - Undo

    func canUndo() -> Bool {
        !state.moveHistory.isEmpty
    }

    func undoLastMove() {
        guard let lastMove = state.moveHistory.popLast() else { return }

        // Remove the placed stone
        if let position = lastMove.position {
            state.stones[position] = .empty
        }

        // Restore captured stones
        for capturedPos in lastMove.capturedStones {
            state.stones[capturedPos] = lastMove.color.opposite
        }

        // Update captured counts
        if lastMove.color == .black {
            state.capturedWhite -= lastMove.capturedStones.count
        } else {
            state.capturedBlack -= lastMove.capturedStones.count
        }

        // Restore Ko position (simplified - would need full history)
        state.koPosition = nil

        // Switch back to previous player
        state.currentPlayer = lastMove.color

        // Update pass count
        if lastMove.isPass {
            state.passCount = max(0, state.passCount - 1)
        } else {
            state.passCount = 0
        }
    }
}
