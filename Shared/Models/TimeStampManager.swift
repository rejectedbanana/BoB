//
//  TimeStampManager.swift
//  BoB
//
//  Created by Kim Martini on 6/18/24.
//

import Foundation

class TimeStampManager: ObservableObject {
    
    // Human friendly format used in application views
    func viewFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y, HH:mm:ss"
        return formatter.string(from: date)
    }
    
    // Computer friendly format used for naming exported files
    func exportNameFormat(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter.string(from: date)
    }
    
    // Data science friendly format for storing timestamps
    func ISO8601Format(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    // Elapsed Time for logging view
    func elapsedTime(elapsedTime: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: elapsedTime) ?? "00:00:00"
    }
    
    // Change the ISO string back to a date
    func ISO8601StringtoDate(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: isoString)
    }
    
}
