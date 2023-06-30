//
//  FetchWeatherUseCaseMock.swift
//  WeatherAppTests
//
//  Created by Madrit Kacabumi on 30.06.23.
//

import Combine
@testable import WeatherApp
import Foundation

struct FetchWeatherForecastUseCaseMock: FetchWeatherForecastUseCaseType {
    
    let testCounter = TestCounter()
    
    func fetchWeatherForecast(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponseModel, Error> {
        testCounter.increment()
        return Just(WeatherResponseModel(latitude: .zero,
                                         longitude: .zero,
                                         elevation: .zero,
                                         currentWeather: CurrentWeatherModel(temperature: .zero,
                                                                             time: Date()),
                                         hourly: WeatherHourlyModel(time: [], temperature: []),
                                         daily: WeatherDailyModel(time: [],
                                                                  sunrise: [],
                                                                  sunset: [],
                                                                  minTemp: [],
                                                                  maxTemp: [])))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
}
