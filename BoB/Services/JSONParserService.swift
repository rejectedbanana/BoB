//
//  JSONParserService.swift
//  BoB
//
//  Created by Hasan Armoush on 06/09/2024.
//

import Foundation

protocol JSONParserService {
    func parse(_ jsonString: String) -> Any?
    func convertToString(_ jsonObject: Any) -> String?
}

class DefaultJSONParserService: JSONParserService {
    
    func parse(_ jsonString: String) -> Any? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return jsonObject
        } catch {
            debugPrint("Error parsing JSON: \(error)")
            return nil
        }
    }

    func convertToString(_ jsonObject: Any) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            debugPrint("Error converting JSON to string: \(error)")
            return nil
        }
    }
}
