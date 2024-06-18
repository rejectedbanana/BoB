//
//  TimeStampManager.swift
//  BoB
//
//  Created by Kim Martini on 6/18/24.
//

import Foundation

class TimeStampManager: ObservableObject {
    
    // Human friendly format used in views
    func viewFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y, HH:mm:ss"
        return formatter.string(from: date)
    }
    
    // Computer Timfriendly format used for exporting and naming
    func exportNameFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: date)
    }
    
    // Used for timestamp in the CSV
    func ISO8601Format(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    // Elapsed Time
    func elapsedTime(elapsedTime: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: elapsedTime) ?? "00:00:00"
    }
    
}
