//
//  WeatherResponseModel.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation

// MARK: - WeatherResponseModel

struct WeatherResponseModel: Codable {
    let latitude: Double
    let longitude: Double
    let elevation: Float
    let currentWeather: CurrentWeatherModel
    let hourly: WeatherHourlyModel
    let daily: WeatherDailyModel
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, elevation
        case currentWeather = "current_weather"
        case hourly, daily
    }
}

// MARK: - CurrentWeather

struct CurrentWeatherModel: Codable {
    let temperature: Float
    let windSpeed: Double
    let windDirection: Double
    let time: Date
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case time
    }
}

extension CurrentWeatherModel {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(Float.self, forKey: .temperature)
        self.windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        self.windDirection = try container.decode(Double.self, forKey: .windDirection)
        
        let dateString = try container.decode(String.self, forKey: .time)
        guard let formattedDate = DateFormatterUtils.dateFromString(dateString: dateString, format: "yyyy-MM-dd'T'HH:mm") else {
            throw DateFormatterUtils.invalidParsingDate
        }
        self.time = formattedDate
    }
}

// MARK: - WeatherHourlyModel

struct WeatherHourlyModel: Codable {
    let time: [Date]
    let temperature: [Float]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
    }
}

extension WeatherHourlyModel {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode([String].self, forKey: .time).map {
            guard let formatedDate = DateFormatterUtils.dateFromString(dateString: $0, format: "yyyy-MM-dd'T'HH:mm") else {
                throw DateFormatterUtils.invalidParsingDate
            }
            return formatedDate
        }
        self.temperature =  try container.decode([Float].self, forKey: .temperature)
    }
}

// MARK: - WeatherDailyModel

struct WeatherDailyModel: Codable {
    let time: [Date]
    let sunrise: [Date]
    let sunset: [Date]
    let minTemp: [Float]
    let maxTemp: [Float]
    
    enum CodingKeys: String, CodingKey {
        case time, sunrise, sunset
        case minTemp = "temperature_2m_min"
        case maxTemp = "temperature_2m_max"
    }
}

extension WeatherDailyModel {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.time = try container.decode([String].self, forKey: .time).map {
            guard let formatedDate = DateFormatterUtils.dateFromString(dateString: $0, format: "yyyy-MM-dd") else {
                throw DateFormatterUtils.invalidParsingDate
            }
            return formatedDate
        }
        self.sunrise = try container.decode([String].self, forKey: .sunrise).map {
            guard let formatedDate = DateFormatterUtils.dateFromString(dateString: $0, format: "yyyy-MM-dd'T'HH:mm") else {
                throw DateFormatterUtils.invalidParsingDate
            }
            return formatedDate
        }
        
        self.sunset = try container.decode([String].self, forKey: .sunset).map {
            guard let formatedDate = DateFormatterUtils.dateFromString(dateString: $0, format: "yyyy-MM-dd'T'HH:mm") else {
                throw DateFormatterUtils.invalidParsingDate
            }
            return formatedDate
        }
        self.minTemp = try container.decode([Float].self, forKey: .minTemp)
        self.maxTemp = try container.decode([Float].self, forKey: .maxTemp)
    }
}
