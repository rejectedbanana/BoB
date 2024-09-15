//
//  LogDataView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//
import SwiftUI

struct LogDataView: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationDataManager = LocationDataManager()
    @ObservedObject var sensorManager = SensorManager()
    @ObservedObject private var metadataLogger = MetadataLogger()
    @ObservedObject var waterSubmersionManager = WaterSubmersionManager.shared
    
    
    @State private var showSamplingMessage: Bool = false
    
    // Toggle to turn data logging on and off
    @AppStorage("isSamplingActive") private var isLoggingData: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HeaderView(title: "Time, Lat, Lon")
                DataRowView(label: "Time",
                            value1: sensorManager.elapsedTime,
                            value2: formattedLocation())
                .padding(.horizontal, 5)
                HeaderView(title: "Motion: x, y, z")
                MotionDataRowView(title: "Acc",
                                  xValue: sensorManager.accX,
                                  yValue: sensorManager.accY,
                                  zValue: sensorManager.accZ,
                                  stringFormat: "%4.2f")
                MotionDataRowView(title: "Gyr",
                                  xValue: sensorManager.gyrX,
                                  yValue: sensorManager.gyrY,
                                  zValue: sensorManager.gyrZ,
                                  stringFormat: "%4.2f")
                MotionDataRowView(title: "Mag",
                                  xValue: sensorManager.magX,
                                  yValue: sensorManager.magY,
                                  zValue: sensorManager.magZ,
                                  stringFormat: "%3.1f")
                HeaderView(title: "Water: depth, temp")
                WaterDataView(depth: latestWaterDepth(),
                              temperature: latestWaterTemperature())
                .padding(.horizontal, 5)
                if showSamplingMessage {
                    SamplingMessageView(message: "Sampling started, waterlock on", color: .green)
                }
                ControlButtonView(isLogging: $isLoggingData,
                                  startAction: {
                    startSampling()
                },
                                  stopAction: {
                    stopSampling()
                })
            }
            .padding(.horizontal, 10)
            .onAppear {
                clearData()
                if isLoggingData {
                    startSampling()
                }
            }
            .onDisappear {
                clearData()
                if isLoggingData {
                    stopSampling()
                }
            }
            .navigationBarBackButtonHidden(isLoggingData)
            .padding(.top, 10)
            .onReceive(waterSubmersionManager.$submersionDataSamples) { sample in
                debugPrint("New submersion data received, updating view. \(sample)")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formattedLocation() -> String {
        switch locationDataManager.locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            let currentLat = locationDataManager.locationManager.location?.coordinate.latitude ?? Double.nan
            let currentLon = locationDataManager.locationManager.location?.coordinate.longitude ?? Double.nan
            return String(format: "%.6f", currentLat) + ", " + String(format: "%.6f", currentLon)
            
        case .restricted, .denied:
            return "Denied."
            
        case .notDetermined:
            return "Finding..."
            
        default:
            return "Loading..."
        }
    }
    
    private func latestWaterDepth() -> Double? {
        return waterSubmersionManager.submersionDataSamples.last?.depth
    }
    
    private func latestWaterTemperature() -> Double? {
        return waterSubmersionManager.submersionDataSamples.last?.temperature
    }
    
    // MARK: - Sampling Methods
    
    private func startSampling() {
        // Start sampling using the managers
        SamplingService.shared.startSampling(sensorManager: sensorManager,
                                            locationDataManager: locationDataManager,
                                            metadataLogger: metadataLogger,
                                            waterSubmersionManager: waterSubmersionManager)
        
        // Show the sampling message with animation
        withAnimation {
            showSamplingMessage = true
        }
        
        // Hide the message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSamplingMessage = false
            }
        }
    }
    
    private func stopSampling() {
        // Stop sampling using the managers
        SamplingService.shared.stopSampling(sensorManager: sensorManager,
                                           locationDataManager: locationDataManager,
                                           metadataLogger: metadataLogger,
                                           waterSubmersionManager: waterSubmersionManager,
                                           context: moc,
                                           dismiss: dismiss.callAsFunction)
    }
    
    private func clearData() {
        sensorManager.clear()
        locationDataManager.clear()
        waterSubmersionManager.clear()
    }
}

#Preview {
    LogDataView()
}
