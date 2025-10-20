//
//  GoMasterApp.swift
//  GoMaster
//
//  Created by Expert Swift Developer
//  Copyright © 2025 GoMaster. All rights reserved.
//

import SwiftUI
import UserNotifications

@main
struct GoMasterApp: App {
    @StateObject private var gameManager = GameManager()
    @StateObject private var audioManager = AudioManager()
    @State private var showIntro = true

    init() {
        setupNotifications()
        setupAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showIntro {
                    IntroView(isShowing: $showIntro)
                        .transition(.opacity)
                } else {
                    ContentView()
                        .environmentObject(gameManager)
                        .environmentObject(audioManager)
                }
            }
            .preferredColorScheme(.light)
        }
    }

    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    private func setupAppearance() {
        // Configure San Francisco Pro font as default
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let sanFrancisco = UIFont(name: "SFProDisplay-Regular", size: descriptor.pointSize) ?? UIFont.systemFont(ofSize: descriptor.pointSize)
        UILabel.appearance().font = sanFrancisco
    }
}
