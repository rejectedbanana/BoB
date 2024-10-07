//
//  LogDataView.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 10/19/23.
//

import Foundation
import SwiftUI
import CoreLocation

struct LogDataView: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    // pull in managers to take meta, location, motion and waterSubmersion data
    @ObservedObject private var metadataManager = MetadataManager()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var motionManager = MotionManager()
    @ObservedObject var waterSubmersionManager = WaterSubmersionManager.shared
    
    // Toggle to show sampling message
    @State private var showSamplingMessage: Bool = false
    
    // Toggle to turn data logging on and off
    @AppStorage("isSamplingActive") private var isLoggingData: Bool = false
    
    var body: some View {
        VStack {
            
            // Static time/location Header
            Text("Time, Lat, Lon")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic time/location data
            HStack{
                Text(motionManager.elapsedTime)
                    .frame(width: 70)
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
            .padding(.leading, 2)
            
            // Static motion header
            Text("Motion: x, y, z")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic motion data
            RawMotionRow(title: "Acc", xValue: motionManager.accX, yValue: motionManager.accY, zValue: motionManager.accZ, stringFormat: "%4.2f")
            RawMotionRow(title: "Gyr", xValue: motionManager.gyrX, yValue: motionManager.gyrY, zValue: motionManager.gyrZ, stringFormat: "%4.2f")
            RawMotionRow(title: "Mag", xValue: motionManager.magX, yValue: motionManager.magY, zValue: motionManager.magZ, stringFormat: "%3.1f")
            
            // Static water data header
            Text("Water: depth, temp")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic water data
            if let latestSample = waterSubmersionManager.waterSubmersionData.last {
                HStack {
                    Text("\(latestSample.depth ?? 0.0) m")
                    Spacer()
                    Text("\(latestSample.temperature ?? 0.0) \(degree())C")
                }
                .padding(.leading, 50)
            } else {
                Text("No data yet")
                    .padding(.leading, 50)
            }
            if showSamplingMessage {
                Text("Sampling started, waterlock on")
                    .font(.headline)
                    .foregroundColor(.green)
                    .transition(.opacity)
                    .padding(.vertical, 16)
            }
            Button {
                isLoggingData.toggle()
                
                if isLoggingData {
                    // Start sampling
                    SamplingService.shared.startSampling(motionManager: motionManager, locationManager: locationManager, metadataManager: metadataManager, waterSubmersionManager: waterSubmersionManager)
                    
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
                } else {
                    // Stop sampling
                    SamplingService.shared.stopSampling(motionManager: motionManager, locationManager: locationManager, metadataManager: metadataManager, waterSubmersionManager: waterSubmersionManager, context: moc, dismiss: dismiss.callAsFunction)
                }
            } label: {
                Text(isLoggingData ? "Stop" : "Start")
            }
            .tint(.fandango)
            .frame(width: 160, height: 35)
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        }
        .onAppear {
            motionManager.clear()
            locationManager.clear()
            waterSubmersionManager.clear()
        }
        .onDisappear {
            motionManager.clear()
            locationManager.clear()
            waterSubmersionManager.clear()
        }
        .navigationBarBackButtonHidden(isLoggingData)
        .padding(.top, 10)
//        .onReceive(waterSubmersionManager.$waterSubmersionData) { sample in
//            debugPrint("New submersion data received, updating view. \(sample)")
//        }
    }
    
    
}

#Preview {
    LogDataView()
}
