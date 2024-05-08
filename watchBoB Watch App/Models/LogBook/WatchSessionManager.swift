//
//  WatchSessionManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 5/1/24.
//

import Foundation
import WatchConnectivity

// Send Core Data to iPhone using a button
class WatchSessionManager: NSObject, WCSessionDelegate {
    // ChatGPT
//    static let shared = WatchSessionManager()
//    private override init() {
//        super.init()
//    }
//    
//    func startSession() {
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//        }
//    }
    
    // scriptpapi
    var session: WCSession
    // make the memberwise initializer
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }

    // Implement the necesssary delegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // Handle application completion
    }
    
    // Send data method
    func sendDataToPhone(_ data: Data) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessageData(data, replyHandler: nil) {error in
                print("Error sending data: \(error.localizedDescription)")
            }
        }
    }
    
    deinit {
        print("Watch Session Manager class is dead.")
    }
}
