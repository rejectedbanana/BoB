//
//  StartSamplingIntent.swift
//  BoB
//
//  Created by Hasan Armoush on 19/08/2024.
//


import AppIntents

struct StartSamplingIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Sampling"
    
    func perform() async throws -> some IntentResult {
        startSampling()
        return .result(dialog: "Sampling Session Started")
    }
    
    private func startSampling() {
        
    }
}

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartSamplingIntent(),
            phrases: ["Start data sampling with \(.applicationName)"],
            shortTitle: "Start Sampling",
            systemImageName: "figure.walk.scuba"
        )
    }
}
