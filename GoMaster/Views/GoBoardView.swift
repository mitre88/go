//
//  GoBoardView.swift
//  GoMaster
//
//  Beautiful Go board with realistic rendering
//

import SwiftUI

struct GoBoardView: View {
    let gameState: GameState
    let lastMove: BoardPosition?
    let onIntersectionTapped: (BoardPosition) -> Void

    @State private var stoneAnimations: [BoardPosition: Bool] = [:]

    var body: some View {
        GeometryReader { geometry in
            // Use more screen space - multiply by 0.95 for better sizing
            let size = min(geometry.size.width, geometry.size.height) * 0.95
            // Reduce padding - use smaller divisor
            let cellSize = size / (CGFloat(gameState.boardSize) + 0.5)

            ZStack {
                // Board background
                BoardBackground()

                // Grid lines
                GridLines(boardSize: gameState.boardSize, cellSize: cellSize)

                // Star points (for 19x19 board)
                if gameState.boardSize == 19 {
                    StarPoints(cellSize: cellSize)
                }

                // Stones
                ForEach(Array(gameState.stones.keys), id: \.self) { position in
                    if let color = gameState.stones[position], color != .empty {
                        StoneView(
                            color: color,
                            isLastMove: position == lastMove,
                            isAnimating: stoneAnimations[position] ?? false
                        )
                        .frame(width: cellSize * 0.9, height: cellSize * 0.9)
                        .position(
                            x: CGFloat(position.col + 1) * cellSize,
                            y: CGFloat(position.row + 1) * cellSize
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }

                // Invisible tap targets
                ForEach(0..<gameState.boardSize, id: \.self) { row in
                    ForEach(0..<gameState.boardSize, id: \.self) { col in
                        let position = BoardPosition(row, col)
                        Color.clear
                            .frame(width: cellSize, height: cellSize)
                            .position(
                                x: CGFloat(col + 1) * cellSize,
                                y: CGFloat(row + 1) * cellSize
                            )
                            .contentShape(Circle())
                            .onTapGesture {
                                handleTap(at: position)
                            }
                    }
                }
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func handleTap(at position: BoardPosition) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            stoneAnimations[position] = true
        }

        onIntersectionTapped(position)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            stoneAnimations[position] = false
        }
    }
}

// MARK: - Board Background

struct BoardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.87, green: 0.72, blue: 0.53),
                        Color(red: 0.82, green: 0.67, blue: 0.48),
                        Color(red: 0.78, green: 0.63, blue: 0.44)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        Color(red: 0.6, green: 0.45, blue: 0.3),
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
            .padding(8)
    }
}

// MARK: - Grid Lines

struct GridLines: View {
    let boardSize: Int
    let cellSize: CGFloat

    var body: some View {
        Canvas { context, size in
            for i in 0..<boardSize {
                let offset = CGFloat(i + 1) * cellSize

                // Vertical lines
                var verticalPath = Path()
                verticalPath.move(to: CGPoint(x: offset, y: cellSize))
                verticalPath.addLine(to: CGPoint(x: offset, y: CGFloat(boardSize) * cellSize))
                context.stroke(
                    verticalPath,
                    with: .color(Color.black.opacity(0.8)),
                    lineWidth: 1
                )

                // Horizontal lines
                var horizontalPath = Path()
                horizontalPath.move(to: CGPoint(x: cellSize, y: offset))
                horizontalPath.addLine(to: CGPoint(x: CGFloat(boardSize) * cellSize, y: offset))
                context.stroke(
                    horizontalPath,
                    with: .color(Color.black.opacity(0.8)),
                    lineWidth: 1
                )
            }
        }
        .padding(8)
    }
}

// MARK: - Star Points

struct StarPoints: View {
    let cellSize: CGFloat

    var body: some View {
        let starPositions: [(Int, Int)] = [
            (3, 3), (3, 9), (3, 15),
            (9, 3), (9, 9), (9, 15),
            (15, 3), (15, 9), (15, 15)
        ]

        ForEach(starPositions.indices, id: \.self) { index in
            let (row, col) = starPositions[index]
            Circle()
                .fill(Color.black.opacity(0.7))
                .frame(width: cellSize * 0.15, height: cellSize * 0.15)
                .position(
                    x: CGFloat(col + 1) * cellSize,
                    y: CGFloat(row + 1) * cellSize
                )
        }
        .padding(8)
    }
}

// MARK: - Stone View

struct StoneView: View {
    let color: StoneColor
    let isLastMove: Bool
    let isAnimating: Bool

    var body: some View {
        ZStack {
            // Shadow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 25
                    )
                )
                .offset(y: 3)
                .blur(radius: 3)

            // Stone body
            Circle()
                .fill(
                    RadialGradient(
                        colors: color == .black ?
                            [Color.gray.opacity(0.4), Color.black, Color.black] :
                            [Color.white, Color.white, Color.gray.opacity(0.3)],
                        center: .init(x: 0.3, y: 0.3),
                        startRadius: 0,
                        endRadius: 30
                    )
                )
                .overlay(
                    Circle()
                        .stroke(
                            color == .black ?
                                Color.white.opacity(0.2) :
                                Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: .black.opacity(0.4),
                    radius: 4,
                    x: 2,
                    y: 2
                )

            // Highlight effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(color == .black ? 0.3 : 0.6),
                            Color.clear
                        ],
                        center: .init(x: 0.3, y: 0.3),
                        startRadius: 0,
                        endRadius: 15
                    )
                )
                .blur(radius: 2)

            // Last move indicator
            if isLastMove {
                Circle()
                    .stroke(color == .black ? Color.white : Color.black, lineWidth: 3)
                    .scaleEffect(0.4)

                Circle()
                    .fill(color == .black ? Color.white : Color.black)
                    .scaleEffect(0.15)
            }
        }
        .scaleEffect(isAnimating ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)
    }
}

#Preview {
    let gameState = GameState(
        boardSize: 19,
        currentPlayer: .black,
        stones: [
            BoardPosition(3, 3): .black,
            BoardPosition(3, 4): .white,
            BoardPosition(4, 3): .white,
            BoardPosition(15, 15): .black,
            BoardPosition(9, 9): .white
        ]
    )

    return GoBoardView(
        gameState: gameState,
        lastMove: BoardPosition(9, 9),
        onIntersectionTapped: { _ in }
    )
    .frame(width: 400, height: 400)
    .padding()
}
