//
//  ScoresView.swift
//  GoMaster
//
//  Scores and statistics view
//

import SwiftUI
import Charts

struct ScoresView: View {
    @EnvironmentObject var gameManager: GameManager

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
                    VStack(spacing: 24) {
                        // Statistics summary
                        StatisticsSummaryView()
                            .environmentObject(gameManager)
                            .padding(.horizontal)
                            .padding(.top)

                        // Win rate chart
                        if !gameManager.scores.isEmpty {
                            WinRateChartView()
                                .environmentObject(gameManager)
                                .padding(.horizontal)
                        }

                        // Recent games
                        RecentGamesView()
                            .environmentObject(gameManager)
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Marcadores")
            .toolbar {
                if !gameManager.scores.isEmpty {
                    Button(role: .destructive) {
                        gameManager.clearScores()
                    } label: {
                        Label("Limpiar", systemImage: "trash")
                    }
                }
            }
        }
    }
}

// MARK: - Statistics Summary

struct StatisticsSummaryView: View {
    @EnvironmentObject var gameManager: GameManager

    var totalGames: Int {
        gameManager.scores.count
    }

    var wins: Int {
        gameManager.scores.filter { $0.won }.count
    }

    var losses: Int {
        totalGames - wins
    }

    var winRate: Double {
        totalGames > 0 ? Double(wins) / Double(totalGames) * 100 : 0
    }

    var averageScore: Double {
        guard !gameManager.scores.isEmpty else { return 0 }
        let total = gameManager.scores.reduce(0.0) { $0 + $1.score }
        return total / Double(gameManager.scores.count)
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Estadísticas")
                .font(.title2.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Partidas",
                    value: "\(totalGames)",
                    icon: "gamecontroller.fill",
                    color: .blue
                )

                StatCard(
                    title: "Victorias",
                    value: "\(wins)",
                    icon: "trophy.fill",
                    color: .yellow
                )

                StatCard(
                    title: "Derrotas",
                    value: "\(losses)",
                    icon: "flag.fill",
                    color: .red
                )

                StatCard(
                    title: "Tasa de Victoria",
                    value: String(format: "%.1f%%", winRate),
                    icon: "chart.line.uptrend.xyaxis",
                    color: .green
                )
            }
        }
        .padding(20)
        .background(LiquidGlassCard())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.5))
        )
    }
}

// MARK: - Win Rate Chart

struct WinRateChartView: View {
    @EnvironmentObject var gameManager: GameManager

    var chartData: [(String, Int)] {
        let wins = gameManager.scores.filter { $0.won }.count
        let losses = gameManager.scores.count - wins
        return [
            ("Victorias", wins),
            ("Derrotas", losses)
        ]
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Proporción de Resultados")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 40) {
                ForEach(chartData, id: \.0) { item in
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                                .frame(width: 100, height: 100)

                            Circle()
                                .trim(from: 0, to: CGFloat(item.1) / CGFloat(max(gameManager.scores.count, 1)))
                                .stroke(
                                    item.0 == "Victorias" ?
                                        LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                        LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(-90))

                            Text("\(item.1)")
                                .font(.system(size: 24, weight: .bold))
                        }

                        Text(item.0)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(LiquidGlassCard())
    }
}

// MARK: - Recent Games

struct RecentGamesView: View {
    @EnvironmentObject var gameManager: GameManager

    var body: some View {
        VStack(spacing: 16) {
            Text("Partidas Recientes")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            if gameManager.scores.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)

                    Text("No hay partidas registradas")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(gameManager.scores.prefix(10)) { score in
                        GameScoreRow(score: score)
                    }
                }
            }
        }
        .padding(20)
        .background(LiquidGlassCard())
    }
}

struct GameScoreRow: View {
    let score: PlayerScore

    var body: some View {
        HStack(spacing: 16) {
            // Result indicator
            ZStack {
                Circle()
                    .fill(score.won ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: score.won ? "checkmark" : "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(score.won ? .green : .red)
            }

            // Game info
            VStack(alignment: .leading, spacing: 4) {
                Text(score.won ? "Victoria" : "Derrota")
                    .font(.body.weight(.semibold))

                Text(score.difficulty.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Score
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", score.score))
                    .font(.body.weight(.bold))

                Text(score.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.5))
        )
    }
}

#Preview {
    ScoresView()
        .environmentObject(GameManager())
}
