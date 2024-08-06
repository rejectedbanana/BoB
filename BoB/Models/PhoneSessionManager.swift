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
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        
        if WCSession.isSupported() {
            self.session.delegate = self
            session.activate()
        }
    }
    
    @Published var receivedMessage = ""
    @Published var receivedDictionary: [String: Any] = [:]
    
    // MARK: - WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        session.activate() // Reactivate the session
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            if let receivedString = message["message"] as? String {
                self.receivedMessage = receivedString
                print("Received message: \(self.receivedMessage)")
                UserDefaults.standard.set(self.receivedMessage, forKey: "message")
                print("String saved to UserDefaults")
            } else {
                self.receivedDictionary = message
                print("Received dictionary from watch.")
                for (key, value) in self.receivedDictionary {
                    print("receivedDictionary[\(key)] = \(value)")
                }
                UserDefaults.standard.set(self.receivedDictionary, forKey: "dictionary")
                print("Dictionary saved to UserDefaults")
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("Received message data: \(String(data: messageData, encoding: .utf8) ?? "Invalid data")")
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(SampleSet.self, from: messageData)
            print("Decoded data: \(data)")
        } catch {
            print("Failed to decode the received data: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Retrieve watch data stored in UserDefaults
    func getMessageFromWatch() -> String {
        let message = UserDefaults.standard.string(forKey: "message") ?? ""
        print("Retrieved message from UserDefaults: \(message)")
        return message
    }
    
    func getDictionaryFromWatch() -> [String: Any] {
        let dictionary = UserDefaults.standard.dictionary(forKey: "dictionary") ?? [:]
        print("Retrieved dictionary from UserDefaults: \(dictionary)")
        return dictionary
    }
    
    deinit {
        print("Phone Session Manager is deinitialized")
    }
}
