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
    // load the CoreData so you can write to it
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    // create the variables to write to CoreData
    @State private var startDatetime: Date = Date()
    //@State private var stopDatetime: Date = Date()
    @State private var name: String = ""
    @State private var startLatitude: CLLocationDegrees? = nil
    @State private var startLongitude: CLLocationDegrees? = nil
    
    // create the location manager in ContentView, then pull it in here
    // @EnvironmentObject var locationDataManager: LocationDataManager
    // create the location manager here
    @StateObject var locationDataManager = LocationDataManager()
    
    // pull in the sensor manager to take data
    @ObservedObject var sensorManager = SensorManager()
    
    // Toggle to turn data logging on and off
    @State private var isLoggingData = false
    
    @EnvironmentObject var settings: SettingsManager
    @EnvironmentObject var metadataLogger: MetadataLogger
    
    var body: some View {
        VStack {
            
            // Static time/location Header
            Text("Position: time, lat/lon")
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
            Text("Water: depth, temp, light")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.silver)
                .padding(.leading, 5)
            
            // Dynamic water data
            HStack{
                Text("10 m")
                Spacer()
                Text("17.1 \(degree())C")
                Spacer()
                Text("54%")
            }
            .padding(.leading, 50)
            
            // Button start logging data
            Button {
                isLoggingData.toggle()
                
                if isLoggingData {
                    // take some metadata
                    startDatetime = Date()
                    name = timeStampFormatter(startDatetime)
                    startLatitude = locationDataManager.locationManager.location?.coordinate.latitude ?? Double.nan
                    startLongitude = locationDataManager.locationManager.location?.coordinate.longitude ?? Double.nan

                    // start taking data
                    metadataLogger.startLogging()
                    sensorManager.startLogging(settings.samplingFrequency)
                } else {
                    // stop taking data
                    sensorManager.stopLogging()
                    metadataLogger.stopLogging(stopCoordinates: CLLocationCoordinate2D(latitude: startLatitude ?? 0.0, longitude: startLongitude ?? 0.0))
        
                    // take some more metadata
                    //stopDatetime = Date()
                    
                    // create a new log entry to save to CoreData
                    let stopDatetime = Date()
                    let newEntry = LogBookRecord(context: moc)
                    newEntry.id = UUID()
                    newEntry.startDatetime = startDatetime
                    newEntry.stopDatetime = stopDatetime
                    newEntry.name = name
                    newEntry.startLatitude = startLatitude ?? 0.0
                    newEntry.startLongitude = startLongitude ?? 0.0
                    // save to CoreData
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
