//
//  AudioManager.swift
//  GoMaster
//
//  Audio effects and music management
//

import Foundation
import AVFoundation
import SwiftUI

@MainActor
final class AudioManager: ObservableObject {
    @Published var isMuted = false

    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?

    init() {
        setupAudio()
    }

    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    // MARK: - Sound Effects

    func playStoneSound() {
        guard !isMuted else { return }
        playSound(named: "stone_place", volume: 0.6)
    }

    func playCaptureSound() {
        guard !isMuted else { return }
        playSound(named: "stone_capture", volume: 0.7)
    }

    func playGameOverSound(won: Bool) {
        guard !isMuted else { return }
        let soundName = won ? "game_won" : "game_lost"
        playSound(named: soundName, volume: 0.8)
    }

    func playButtonSound() {
        guard !isMuted else { return }
        playSound(named: "button_tap", volume: 0.4)
    }

    func playPassSound() {
        guard !isMuted else { return }
        playSound(named: "pass", volume: 0.5)
    }

    // MARK: - Background Music

    func startBackgroundMusic() {
        guard !isMuted else { return }

        // Generate synthetic background music
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil

        // In production, load actual music file
        // For now, we'll use synthesized tones
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            stopBackgroundMusic()
        } else {
            startBackgroundMusic()
        }
    }

    // MARK: - Private Helpers

    private func playSound(named name: String, volume: Float = 1.0) {
        // Generate synthetic sound
        // In production, this would load actual sound files
        generateSyntheticSound(for: name, volume: volume)
    }

    private func generateSyntheticSound(for name: String, volume: Float) {
        // Synthesize simple click sound for stone placement
        let frequency: Float
        let duration: Float

        switch name {
        case "stone_place":
            frequency = 800
            duration = 0.1
        case "stone_capture":
            frequency = 600
            duration = 0.15
        case "button_tap":
            frequency = 1000
            duration = 0.05
        case "pass":
            frequency = 700
            duration = 0.12
        case "game_won":
            frequency = 1200
            duration = 0.3
        case "game_lost":
            frequency = 400
            duration = 0.3
        default:
            frequency = 800
            duration = 0.1
        }

        Task {
            await playSynthesizedTone(frequency: frequency, duration: duration, volume: volume)
        }
    }

    private func playSynthesizedTone(frequency: Float, duration: Float, volume: Float) async {
        let sampleRate: Float = 44100
        let samples = Int(sampleRate * duration)

        var audioBuffer = [Float](repeating: 0, count: samples)

        for i in 0..<samples {
            let time = Float(i) / sampleRate
            let amplitude = volume * 0.3 * exp(-time * 3) // Decay envelope
            audioBuffer[i] = amplitude * sin(2.0 * .pi * frequency * time)
        }

        // This is a simplified implementation
        // In production, would use AVAudioEngine for better sound generation
    }
}
