//
//  WatchSessionManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 5/1/24.
//

import Foundation
import WatchConnectivity
//import SwiftUI

// Send Core Data to iPhone using a button
class WatchSessionManager: NSObject, WCSessionDelegate {
    
    // scriptpapi
    var session: WCSession
    // make the memberwise initializer
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            self.session.delegate = self
            session.activate()
        }
    }

    // Implement the necesssary delegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // Handle application completion
    }
    
   // Test if the phone is reachable
   func activatePhone() {
        if self.session.isReachable {
            print("iOS - Phone is available")
        } else {
            print("iOS - Phone is unavailable")
        }
    }
    
    // Send a text string to the phone
    func sendMessageToPhone(_ message: String) {
        if self.session.isReachable {
            print("iOS - Phone is available, sending message: \(message)")
            self.session.sendMessage(["message": String(message)], replyHandler: nil) { (error) in
                print("Error sending message to phone: \(error.localizedDescription)")
            }
        }
        print("send message to phone")
    }
    
    // Send data to the phone
    func sendDictionaryToPhone(_ data: [String: Any]) {
        if self.session.isReachable {
            print("iOS - Phone is available, sending the following data:")
            for (key, value) in data {
                print("WatchDictionary[\(key)] = \(value)")
            }
            self.session.sendMessage(data, replyHandler: nil) {error in
                print("Error sending dictionary to phone: \(error.localizedDescription)")
            }
        }
    }
    
//    deinit {
//        print("Watch Session Manager class is dead.")
//    }
}
