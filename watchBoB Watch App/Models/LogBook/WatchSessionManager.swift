//
//  WatchSessionManager.swift
//  watchBoB Watch App
//
//  Created by Kim Martini on 5/1/24.
//
import Foundation
import WatchConnectivity

// Send Core Data to iPhone using a button
class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            self.session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    func activatePhone() {
        if self.session.isReachable {
            print("Phone is reachable")
        } else {
            print("Phone is not reachable")
        }
    }
    
    func sendMessageToPhone(_ message: String) {
        if self.session.isReachable {
            self.session.sendMessage(["message": message], replyHandler: nil) { error in
                print("Error sending message to phone: \(error.localizedDescription)")
            }
        } else {
            print("Phone is not reachable")
        }
    }
    
    func sendDictionaryToPhone(_ data: [String: Any]) {
        if self.session.isReachable {
            self.session.sendMessage(data, replyHandler: nil) { error in
                print("Error sending dictionary to phone: \(error.localizedDescription)")
            }
        } else {
            print("Phone is not unreachable")
        }
    }
    
    func sendDataToPhone(_ dataModel: SampleSet) {
        if self.session.isReachable {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let data = try encoder.encode(dataModel)
                self.session.sendMessageData(data, replyHandler: nil) { error in
                    print("Error sending data: \(error.localizedDescription)")
                }
                print("Encoded data: \(String(data: data, encoding: .utf8)!)")
            } catch {
                print("Failed to encode data: \(error.localizedDescription)")
            }
        } else {
            print("Phone is not reachable")
        }
    }
    
    deinit {
        print("Watch Session Manager is deinitialized")
    }
}
