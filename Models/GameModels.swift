//
//  GameModels.swift
//  GoMaster
//
//  Core game models for Go
//

import Foundation
import SwiftUI

// MARK: - Stone Color

enum StoneColor: Int, Codable {
    case black = 1
    case white = -1
    case empty = 0

    var opposite: StoneColor {
        switch self {
        case .black: return .white
        case .white: return .black
        case .empty: return .empty
        }
    }

    var displayColor: Color {
        switch self {
        case .black: return .black
        case .white: return .white
        case .empty: return .clear
        }
    }

    var displayName: String {
        switch self {
        case .black: return "Negras"
        case .white: return "Blancas"
        case .empty: return ""
        }
    }
}

// MARK: - Board Position

struct BoardPosition: Hashable, Codable {
    let row: Int
    let col: Int

    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }

    var neighbors: [BoardPosition] {
        [
            BoardPosition(row - 1, col),
            BoardPosition(row + 1, col),
            BoardPosition(row, col - 1),
            BoardPosition(row, col + 1)
        ]
    }
}

// MARK: - Stone

struct Stone: Identifiable, Hashable {
    let id = UUID()
    let position: BoardPosition
    let color: StoneColor
    var isLastMove: Bool = false
    var isCaptured: Bool = false

    func hash(into hasher: inout Hasher) {
        hasher.combine(position)
        hasher.combine(color)
    }

    static func == (lhs: Stone, rhs: Stone) -> Bool {
        lhs.position == rhs.position && lhs.color == rhs.color
    }
}

// MARK: - Group (for liberty calculation)

struct Group {
    let stones: Set<BoardPosition>
    let color: StoneColor
    let liberties: Set<BoardPosition>

    var isDead: Bool {
        liberties.isEmpty
    }
}

// MARK: - Game State

struct GameState: Codable {
    var boardSize: Int = 19
    var currentPlayer: StoneColor = .black
    var stones: [BoardPosition: StoneColor] = [:]
    var capturedBlack: Int = 0
    var capturedWhite: Int = 0
    var passCount: Int = 0
    var moveHistory: [Move] = []
    var koPosition: BoardPosition?

    var territoryBlack: Int = 0
    var territoryWhite: Int = 0

    mutating func reset(boardSize: Int = 19) {
        self.boardSize = boardSize
        self.currentPlayer = .black
        self.stones = [:]
        self.capturedBlack = 0
        self.capturedWhite = 0
        self.passCount = 0
        self.moveHistory = []
        self.koPosition = nil
        self.territoryBlack = 0
        self.territoryWhite = 0
    }
}

// MARK: - Move

struct Move: Codable, Identifiable {
    let id = UUID()
    let position: BoardPosition?
    let color: StoneColor
    let capturedStones: [BoardPosition]
    let timestamp: Date

    var isPass: Bool {
        position == nil
    }
}

// MARK: - Game Result

struct GameResult {
    let winner: StoneColor?
    let blackScore: Double
    let whiteScore: Double
    let blackTerritory: Int
    let whiteTerritory: Int
    let blackCaptures: Int
    let whiteCaptures: Int

    var resultText: String {
        guard let winner = winner else {
            return "Empate"
        }
        let margin = abs(blackScore - whiteScore)
        return "\(winner.displayName) gana por \(String(format: "%.1f", margin)) puntos"
    }
}

// MARK: - Difficulty Level

enum DifficultyLevel: String, CaseIterable, Codable {
    case beginner = "Principiante"
    case intermediate = "Intermedio"
    case advanced = "Avanzado"
    case expert = "Experto"
    case master = "Maestro"

    var aiStrength: Double {
        switch self {
        case .beginner: return 0.3
        case .intermediate: return 0.5
        case .advanced: return 0.7
        case .expert: return 0.9
        case .master: return 1.0
        }
    }

    var thinkingTime: TimeInterval {
        switch self {
        case .beginner: return 0.5
        case .intermediate: return 1.0
        case .advanced: return 2.0
        case .expert: return 3.0
        case .master: return 4.0
        }
    }
}

// MARK: - Player Score

struct PlayerScore: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let playerColor: StoneColor
    let score: Double
    let difficulty: DifficultyLevel
    let won: Bool
}
