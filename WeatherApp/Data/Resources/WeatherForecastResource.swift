//
//  WeatherForecastResource.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation
import Alamofire

struct WeatherForecastResource: APIResource {
    let headers: [String: String]? = [:]
    let httpMethod: HTTPMethod = .get
    let requestURLString: String = {
        return APIConfig.baseApi + "/forecast"
    }()
    let parameters: Parameters?
   
    init(latitude: Double, longitude: Double) {
        
        self.parameters = [
            "latitude": latitude,
            "longitude": longitude,
            "hourly": "temperature_2m",
            "timezone": "Europe/Berlin", // timezone should be injected from outside the resource depending on device timezone
            "daily": "temperature_2m_max,temperature_2m_min,sunrise,sunset",
            "current_weather": true
        ]
    }
}
