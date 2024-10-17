//
//  JSONViewModel.swift
//  BoB
//
//  Created by Hasan Armoush on 15/09/2024.
//


import Foundation
import Combine

class JSONViewModel: ObservableObject {
    @Published var truncatedJSONContent: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func processJSON(_ jsonContent: String, limit: Int = 100) {
        // Perform processing asynchronously
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let data = jsonContent.data(using: .utf8) else {
                DispatchQueue.main.async {
                    self.truncatedJSONContent = jsonContent
                }
                return
            }
            
            do {
                var jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                jsonObject = self.limitJSON(jsonObject, limit: limit)
                
                let truncatedData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
                let truncatedString = String(data: truncatedData, encoding: .utf8) ?? jsonContent
                
                // Update on the main thread
                DispatchQueue.main.async {
                    self.truncatedJSONContent = truncatedString
                }
            } catch {
                print("Error processing JSON: \(error)")
                DispatchQueue.main.async {
                    self.truncatedJSONContent = jsonContent
                }
            }
        }
    }
    
    /// Recursive function to traverse JSON and limit arrays to first 'limit' elements
    private func limitJSON(_ object: Any, limit: Int) -> Any {
        if var array = object as? [Any] {
            if array.count > limit {
                array = Array(array.prefix(limit))
            }
            return array.map { limitJSON($0, limit: limit) }
        } else if var dict = object as? [String: Any] {
            for (key, value) in dict {
                dict[key] = limitJSON(value, limit: limit)
            }
            return dict
        } else {
            return object
        }
    }
}
