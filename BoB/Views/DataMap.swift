//
//  DataMap.swift
//  BoB
//
//  Created by Kim Martini on 3/24/25.
//

import SwiftUI
import MapKit

struct Coordinate: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct DataMap: View {
    let combinedData: StructuredData?
    
    private var coordinates: [Coordinate] {
        return convertLocationToCoordinates()
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
                Marker("Start", coordinate: start.locationCoordinate)
                    .tint(.green)
            }
            
            // End pin
            if let end = coordinates.last {
                Marker("End", coordinate: end.locationCoordinate)
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
    
    // FUNCTIONS TO CONVERT LOCATION ARRAYS TO A COORDINATE STRUCTURES
    private func convertLocationToCoordinates() -> [Coordinate] {
        let timestamp = combinedData?.location.values.timestamp.map(\.self) ?? []
        let latitude = combinedData?.location.values.latitude.map(\.self) ?? []
        let longitude = combinedData?.location.values.longitude.map(\.self) ?? []
        
        var coordinateArray: [Coordinate] = []
        
        for index in timestamp.indices {
            let newLocation = Coordinate(
                latitude: latitude[index] ?? Double.nan,
                longitude: longitude[index] ?? Double.nan
            )
            coordinateArray.append(newLocation)
        }
        
        return coordinateArray
    }
    
}

//#Preview {
//    DataMap()
//}
