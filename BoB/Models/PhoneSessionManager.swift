//
//  PhoneSessionManager.swift
//  BoB
//
//  Created by Kim Martini on 5/1/24.
//

import Foundation
import WatchConnectivity

// Receive Core Data from iPhone
class PhoneSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    // CHATGPT
//    static let shared = PhoneSessionManager()
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
    @Published var receivedMessage = ""
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    // Implement the necessary delegate methods
    // Lets the session know that your app supports asynchronus activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        // Handle activation completion
    }
    // Stubs for conformance
    // Required to manage transitions between different apple watches (only need on iOS, not watchOS)
    // or watch moves away from phone
    func sessionDidBecomeInactive(_ session: WCSession) {
        //
    }
    // Required to manage transitions between different apple watches (only need on iOS, not watchOS)
    // drop the connection and you are not going to get it back
    func sessionDidDeactivate(_ session: WCSession) {
        //
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // Handle received data
        // Assuming data is serializes CoreData objects, deserialize and process here
        DispatchQueue.main.async {
            self.receivedMessage = message["message"] as? String ?? ""
            print("Received message > " + self.receivedMessage)
            // code to save to watch internal memory
            UserDefaults.standard.set(self.receivedMessage, forKey: "message")
        }
    }
    
    deinit {
        print("Phone Session Manager is dead.")
    }
}
