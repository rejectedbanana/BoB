//
//  StartSamplingIntent.swift
//  BoB
//
//  Created by Hasan Armoush on 19/08/2024.
//


import AppIntents
import SwiftUI

struct ToggleSamplingIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Sampling"

    @AppStorage("isSamplingActive") private var isSamplingActive: Bool = false
    
    func perform() async throws -> some IntentResult {
        let service = SamplingService.shared
        if isSamplingActive {
            service.stopSampling(
                sensorManager: SensorManager(),
                locationDataManager: LocationDataManager(),
                metadataLogger: MetadataLogger(),
                waterSubmersionManager: WaterSubmersionManager(),
                context: CoreDataController().container.viewContext,
                dismiss: nil
            )
            return .result(dialog: "Sampling Session Stopped")
        } else {
            service.startSampling(
                sensorManager: SensorManager(),
                locationDataManager: LocationDataManager(),
                metadataLogger: MetadataLogger(),
                waterSubmersionManager: WaterSubmersionManager()
            )
            return .result(dialog: "Sampling Session Started")
        }
    }
}

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ToggleSamplingIntent(),
            phrases: ["Start data sampling with \(.applicationName)"],
            shortTitle: "Start Sampling",
            systemImageName: "figure.walk.scuba"
        )
    }
}
