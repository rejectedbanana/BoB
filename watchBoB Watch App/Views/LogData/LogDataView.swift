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
    
    // create the variables to write to CoreData
    @State private var name: String = "TBD" 

    // create the location manager here
    @StateObject var locationDataManager = LocationDataManager()
    
    // pull in the sensor manager to take data
    @ObservedObject var sensorManager = SensorManager()
    
    // Toggle to turn data logging on and off
    @State private var isLoggingData = false
    
    // pull in the metadataLogger to take metadata
    @ObservedObject private var metadataLogger = MetadataLogger()
    @ObservedObject var waterSubmersionManager = WaterSubmersionManager()
    
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

            // Dynanic motion data
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
            // Button start logging data
            Button {
                isLoggingData.toggle()
                
                if isLoggingData {
                    // take some metadata
                    metadataLogger.startLogging()
                    // start taking data
                    sensorManager.startLogging(10)
                    locationDataManager.startSamplingGPS()
                } else {
                    // stop taking data
                    sensorManager.stopLogging()
                    // take more metadata
                    metadataLogger.stopLogging()
                    locationDataManager.stopSamplingGPS()

                    // create a new log entry to save to CoreData
                    let newEntry = SampleSet(context: moc)
                    newEntry.id = metadataLogger.sessionID
                    newEntry.startDatetime = metadataLogger.startDatetime
                    newEntry.stopDatetime = metadataLogger.stopDatetime
                    newEntry.name = metadataLogger.name
                    newEntry.startLatitude = metadataLogger.startLatitude
                    newEntry.startLongitude = metadataLogger.startLongitude
                    newEntry.stopLatitude = metadataLogger.stopLatitude
                    newEntry.stopLongitude = metadataLogger.stopLongitude
                    newEntry.sampleCSV = sensorManager.data.convertToJSONString()
                    newEntry.gpsJSON = locationDataManager.sampledLocationsToJSON()
                    do {
                        try moc.save()
                    } catch {
                        print("Failed to save log entry: \(error)")
                    }
                    dismiss()
                    
                }
            } label: {
                Text(isLoggingData ? "Stop" : "Start")
            }
            .tint(.fandango)
            .frame(width: 160, height: 35)
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)
        
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 10)
    }
}

#Preview {
    LogDataView()
}
