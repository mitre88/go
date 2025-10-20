//
//  SettingsView.swift
//  GoMaster
//
//  Settings and preferences
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameManager: GameManager
    @EnvironmentObject var audioManager: AudioManager

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
                        // Game settings
                        SettingsSection(title: "Configuración del Juego") {
                            VStack(spacing: 16) {
                                SettingRow(
                                    icon: "square.grid.3x3",
                                    title: "Tamaño del Tablero",
                                    value: "\(gameManager.boardSize)x\(gameManager.boardSize)"
                                )

                                SettingRow(
                                    icon: "brain.head.profile",
                                    title: "Dificultad IA",
                                    value: gameManager.difficulty.rawValue
                                )
                            }
                        }

                        // Audio settings
                        SettingsSection(title: "Audio") {
                            Toggle(isOn: Binding(
                                get: { !audioManager.isMuted },
                                set: { audioManager.isMuted = !$0 }
                            )) {
                                HStack(spacing: 12) {
                                    Image(systemName: audioManager.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .font(.title3)
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [.blue, .purple],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(width: 32)

                                    Text("Sonidos")
                                        .font(.body)
                                }
                            }
                            .tint(.blue)
                        }

                        // About
                        SettingsSection(title: "Acerca de") {
                            VStack(spacing: 16) {
                                SettingRow(
                                    icon: "info.circle",
                                    title: "Versión",
                                    value: "1.0.0"
                                )

                                SettingRow(
                                    icon: "star.fill",
                                    title: "Desarrollador",
                                    value: "GoMaster Team"
                                )
                            }
                        }

                        // Rules
                        SettingsSection(title: "Reglas del Go") {
                            VStack(alignment: .leading, spacing: 12) {
                                RuleItem(
                                    number: 1,
                                    text: "Los jugadores colocan piedras alternadamente en las intersecciones del tablero."
                                )
                                RuleItem(
                                    number: 2,
                                    text: "Una piedra o grupo sin libertades (intersecciones vacías adyacentes) es capturada y removida."
                                )
                                RuleItem(
                                    number: 3,
                                    text: "Ko: No se puede repetir inmediatamente la posición anterior del tablero."
                                )
                                RuleItem(
                                    number: 4,
                                    text: "El juego termina cuando ambos jugadores pasan consecutivamente."
                                )
                                RuleItem(
                                    number: 5,
                                    text: "La puntuación se calcula sumando territorio y capturas. El jugador con más puntos gana."
                                )
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding()
                }
            }
            .navigationTitle("Ajustes")
        }
    }
}

// MARK: - Settings Section

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            content()
        }
        .padding(20)
        .background(LiquidGlassCard())
    }
}

// MARK: - Setting Row

struct SettingRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 32)

            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Text(value)
                .font(.body.weight(.medium))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.5))
        )
    }
}

// MARK: - Rule Item

struct RuleItem: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)

                Text("\(number)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.5))
        )
    }
}

#Preview {
    SettingsView()
        .environmentObject(GameManager())
        .environmentObject(AudioManager())
}
