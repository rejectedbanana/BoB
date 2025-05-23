//
//  DataMap.swift
//  BoB
//
//  Created by Kim Martini on 3/24/25.
//

import SwiftUI
import MapKit

struct Coordinate {
    let timestamp: String
    let latitude: Double
    let longitude: Double
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct DataMap: View {
    let locationData: [LocationData]
    
    private var coordinates: [Coordinate] {
        return convertLocationDataToCoordinates()
    }
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map {
            // Draw polyline for the path
            if coordinates.count > 1 {
                MapPolyline(coordinates: coordinates.map(\.locationCoordinate))
                    .stroke(Color.blue, lineWidth: 4)
            }
            
            // Start pin
            if let start = coordinates.first {
                let markerLabel = """
                \(formattedCoordinate(start.locationCoordinate.latitude)) °N
                \(formattedCoordinate(start.locationCoordinate.longitude)) °E
                """
                
                Marker(markerLabel, coordinate: start.locationCoordinate)
                    .tint(.green)
            }
            
            // End pin
            if let end = coordinates.last {
                let markerLabel = """
                \(formattedCoordinate(end.locationCoordinate.latitude)) °N
                \(formattedCoordinate(end.locationCoordinate.longitude)) °E
                """
                
                Marker(markerLabel, coordinate: end.locationCoordinate)
                    .tint(.red)
            }
        }
        .onAppear {
            if let center = coordinates.first?.locationCoordinate {
                region.center = center
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
        
    }
    
    private func formattedCoordinate(_ coordinate: Double) -> String {
        String(format: "%.4f", coordinate)
    }
    
    private func convertLocationDataToCoordinates() -> [Coordinate] {
        var coordinateArray: [Coordinate] = []

        for location in locationData {
            let newLocation = Coordinate(timestamp: location.timestamp, latitude: location.latitude ?? Double.nan, longitude: location.longitude ?? Double.nan)
            coordinateArray.append(newLocation)
        }
        
        return coordinateArray
    }
    
}

#Preview {
  let sampleLocationData = [
    LocationData(timestamp: "2025-05-05T23:25:47.008Z", latitude: 46.85273524379032, longitude: -121.76021503897891),
    LocationData(timestamp: "2025-05-05T23:25:47.020Z", latitude: 46.85273524379032-0.00001, longitude: -121.76021503897891+0.00003),
    LocationData(timestamp: "2025-05-05T23:25:51.872Z", latitude: 46.85273524379032+0.00001, longitude: -121.76021503897891+0.00001),
    LocationData(timestamp: "2025-05-05T23:25:51.877Z", latitude: 46.85273524379032+0.00001, longitude: -121.76021503897891-0.00003)
  ]
    
    DataMap(locationData: sampleLocationData )
}
