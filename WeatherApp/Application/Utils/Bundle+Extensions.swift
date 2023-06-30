//
//  Bundle+Extensions.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation

extension Bundle {
    
    /// Will read a json file from the current Bundle and will parse it
    /// - Parameter jsonFileName: "Json filename without .json extension"
    /// - Returns: Decoded item or nil
    public func decodeLocalJsonFile<E: Decodable>(jsonFileName: String) -> E? {
        if let url = self.url(forResource: jsonFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(E.self, from: data) {
            return decoded
        }
        
        return nil
    }
}
