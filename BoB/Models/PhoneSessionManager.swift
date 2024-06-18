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
    
    // Define the receivedMessage
    @Published var receivedMessage = "" 
    @Published var receivedDictionary: [String: Any] = [:]
    
    
    // MARK: - WCSessionDelegate methods
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
    
    // Handle data received from the watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        // SAVE TO USER DEFAULTS
        // Check if message is a string
        if message["message"] is String {
            // Save received text message to UserDefaults
            DispatchQueue.main.async {
                self.receivedMessage = message["message"] as? String ?? ""
                print("Received message > " + self.receivedMessage)
                // code to save to watch internal memory
                UserDefaults.standard.set(self.receivedMessage, forKey: "message")
                print("String saved to phone memory")
            }
        }
        // Handle other types
        else {
            // Save the received dictionary to UserDefaults
            DispatchQueue.main.async {
                self.receivedDictionary = message
                print("____\\")
                print("Received dictionary from watch.")
                for (key, value) in self.receivedDictionary {
                    print("receivedDictionary[\(key)] = \(value)")
                }
                // some code to save dictionary to watch internal memory
                UserDefaults.standard.set(self.receivedDictionary, forKey: "dictionary")
                print("Dictionary saved to user defaults")
            }
        }
    }
    
    // When the phone received data from the watch, decode it and store it to Core Data
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        // Handle received data
        // Assuming data is serialized CoreData objects, deserialize and process here
    }
    
    // MARK: - retrieve watch data stored in defaults
    // read the message from the watch
    func getMessageFromWatch() -> String {
        var message: String = ""
        
        // retrieve the message
        if let storedReceivedMessage = UserDefaults.standard.string(forKey: "message") {
            message = storedReceivedMessage.description
            print("Successfully retrieved message from phone storage: \(message)")
        } else {
            print("Could not retrieve message from phone storage.")
        }
        
        return message
    }
    
    // read the message from the watch
    func getDictionaryFromWatch() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        // retrieve the message
        if let storedReceivedMessage = UserDefaults.standard.object(forKey: "dictionary") as? [String: Any] {
            dictionary = storedReceivedMessage
            print("Successfully retrieved dictionary from phone storage.")
        } else {
            print("Could not retrieve dictionary from phone storage.")
        }
        return dictionary
    }
    

    
    deinit {
        print("Phone Session Manager is dead.")
    }
}
