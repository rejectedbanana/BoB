//
//  LogDataView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import Foundation
import SwiftUI
import CoreLocation
import WatchKit

struct LogDataView: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    // pull in managers to take meta, location, motion and submersion data
    @ObservedObject private var metadataManager = MetadataManager()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var motionManager = MotionManager()
    @ObservedObject var waterSubmersionManager = WaterSubmersionManager.shared
    @StateObject private var unitsManager = UnitsManager()
    
    // Toggle to show start sampling message
    @State private var showStartSamplingMessage: Bool = false
    
    // Toggle to show stop sampling message
    @State private var showStopSamplingMessage: Bool = false
    
    // Toggle to turn data logging on and off
    @AppStorage("isSamplingActive") private var isLoggingData: Bool = false
    
    // Get the screen width
    private var bigScreen: Bool {
        return isBigScreen()
    }
    
    // check if water submersion is available
    @State var waterSubmersionAvailable: Bool = WaterSubmersionManager.shared.isWaterSubmersionAvailable()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Static time/location Header
            Text("Time, Lat, Lon")
                .foregroundColor(.silver)
                .padding(.leading, bigScreen ? 5 : 0)
            
            // Dynamic time/location data
            HStack{
                Text(motionManager.elapsedTime)
                
                Spacer()
                
                switch locationManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse:
                    let currentLat = locationManager.locationManager.location?.coordinate.latitude ?? Double.nan
                    let currentLon = locationManager.locationManager.location?.coordinate.longitude ?? Double.nan
                    Text(String(format: "%.2f", currentLat) + ", " + String(format: "%.2f", currentLon))
                case .restricted, .denied:
                    Text("Denied.")
                case .notDetermined:
                    Text("Finding...")
                default:
                    ProgressView()
                }
            }
            
            // Static motion header
            Text(unitsManager.motionCoordinateSystem == .earth ? "Motion: North, East, Up" : "Motion: x, y, z")
                .foregroundColor(.silver)
            
            // Dynamic motion data
            RawMotionRow(title: "Acc", xValue: motionManager.accX, yValue: motionManager.accY, zValue: motionManager.accZ, stringFormat: bigScreen ? "%4.2f" :"%4.1f")
            RawMotionRow(title: "Gyr", xValue: motionManager.gyrX, yValue: motionManager.gyrY, zValue: motionManager.gyrZ, stringFormat:  bigScreen ? "%4.2f" :"%4.1f")
            RawMotionRow(title: "Mag", xValue: motionManager.magX, yValue: motionManager.magY, zValue: motionManager.magZ, stringFormat:  bigScreen ? "%3.1f" :"%3.0f")
            
            // Only display submersion data if an Apple Watch Ultra
            if waterSubmersionAvailable {
                // Static water data header
                Text("Water: depth, temp")
                    .foregroundColor(.silver)
                
                // Dynamic water data
                if !waterSubmersionManager.waterSubmersionData.isEmpty {
                    HStack {
                        let depth = waterSubmersionManager.waterSubmersionData.last?.depth ?? 0.0
                        let depthString = String(format: "%.2f", unitsManager.convertDepth(depth).value)
                        Text("\(depthString) \(unitsManager.depthUnitSymbol)")
                        Spacer()
                        let temperature = waterSubmersionManager.waterSubmersionData.last?.temperature ?? 0.0
                        let temperatureString = String(format: "%.1f", unitsManager.convertTemperature(temperature).value)
                        Text("\(temperatureString) \(unitsManager.temperatureUnitSymbol)")
                    }
                } else {
                    Text("No data.")
                }
            }
            
            Spacer()
            
            Button {
                isLoggingData.toggle()
                
                if isLoggingData {
                    // Start sampling
                    SamplingService.shared.startSampling(motionManager: motionManager, locationManager: locationManager, metadataManager: metadataManager, waterSubmersionManager: waterSubmersionManager)
                    
                    // Show the sampling message with animation
                    withAnimation {
                        showStartSamplingMessage = true
                    }
                    
                    // Hide the message after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showStartSamplingMessage = false
                        }
                    }
                } else {
                    // Stop sampling
                    SamplingService.shared.stopSampling(motionManager: motionManager, locationManager: locationManager, metadataManager: metadataManager, waterSubmersionManager: waterSubmersionManager, context: moc, dismiss: dismiss.callAsFunction)
                    
                    // Show the sampling message with animation
                    withAnimation {
                        showStopSamplingMessage = true
                    }
                    
                    // Hide the message after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showStopSamplingMessage = false
                        }
                    }
                }
            } label: {
                Text(isLoggingData ? "Stop" : "Start")
            }
            .sheet(isPresented: $showStartSamplingMessage) {
                if waterSubmersionAvailable {
                    StartSamplingMessageView()
                } else {
                    WaterlockInstructionsView()
                }
            }
            .sheet(isPresented: $showStopSamplingMessage) {
                StopSamplingMessageView()
            }
            .tint(.fandango)
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .onAppear {
            motionManager.clear()
            locationManager.clear()
//            locationManager.locationManagerDidChangeAuthorization(locationManager.locationManager)
            waterSubmersionManager.clear()
        }
        .onDisappear {
            motionManager.clear()
            locationManager.clear()
            waterSubmersionManager.clear()
        }
        .navigationBarBackButtonHidden(isLoggingData)
    }
    
    private func isBigScreen() -> Bool {
        let screenWidth = WKInterfaceDevice.current().screenBounds.width
        if screenWidth > 200 {
            return true
        } else {
            return false
        }
    }
}

#Preview() {
    LogDataView()
}
