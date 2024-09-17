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
    
    @State private var name: String = "TBD"
    @StateObject var locationDataManager = LocationDataManager()
    
    // pull in the sensor manager to take data
    @ObservedObject var sensorManager = SensorManager()
    
    @State private var showSamplingMessage: Bool = false
    
    // Toggle to turn data logging on and off
    @AppStorage("isSamplingActive") private var isLoggingData: Bool = false
    
    // pull in the metadataLogger to take metadata
    @ObservedObject private var metadataLogger = MetadataLogger()
    @ObservedObject var waterSubmersionManager = WaterSubmersionManager.shared
    
    var body: some View {
        VStack {
            
            // Static time/location Header
            Text("Time, Lat, Lon")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic time/location data
            HStack{
                Text(sensorManager.elapsedTime)
                    .frame(width: 70)
                Spacer()
                switch locationDataManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse:
                    let currentLat = locationDataManager.locationManager.location?.coordinate.latitude ?? Double.nan
                    let currentLon = locationDataManager.locationManager.location?.coordinate.longitude ?? Double.nan
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
            RawMotionRow(title: "Acc", xValue: sensorManager.accX, yValue: sensorManager.accY, zValue: sensorManager.accZ, stringFormat: "%4.2f")
            RawMotionRow(title: "Gyr", xValue: sensorManager.gyrX, yValue: sensorManager.gyrY, zValue: sensorManager.gyrZ, stringFormat: "%4.2f")
            RawMotionRow(title: "Mag", xValue: sensorManager.magX, yValue: sensorManager.magY, zValue: sensorManager.magZ, stringFormat: "%3.1f")
            
            // Static water data header
            Text("Water: depth, temp")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic water data
            if let latestSample = waterSubmersionManager.submersionDataSamples.last {
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
                    SamplingService.shared.startSampling(sensorManager: sensorManager, locationDataManager: locationDataManager, metadataLogger: metadataLogger, waterSubmersionManager: waterSubmersionManager)
                    
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
                    SamplingService.shared.stopSampling(sensorManager: sensorManager, locationDataManager: locationDataManager, metadataLogger: metadataLogger, waterSubmersionManager: waterSubmersionManager, context: moc, dismiss: dismiss.callAsFunction)
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
            sensorManager.clear()
            locationDataManager.clear()
            waterSubmersionManager.clear()
        }
        .onDisappear {
            sensorManager.clear()
            locationDataManager.clear()
            waterSubmersionManager.clear()
            SamplingService.shared.stopSampling(sensorManager: sensorManager, locationDataManager: locationDataManager, metadataLogger: metadataLogger, waterSubmersionManager: waterSubmersionManager, context: moc, dismiss: dismiss.callAsFunction)
        }
        .navigationBarBackButtonHidden(isLoggingData)
        .padding(.top, 10)
        .onReceive(waterSubmersionManager.$submersionDataSamples) { sample in
            debugPrint("New submersion data received, updating view. \(sample)")
        }
    }
    
    
}

#Preview {
    LogDataView()
}
