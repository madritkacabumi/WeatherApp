//
//  FetchWeatherForecastUseCase.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Combine

protocol FetchWeatherForecastUseCaseType {
    func fetchWeatherForecast(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponseModel, Error>
}

struct FetchWeatherForecastUseCase: FetchWeatherForecastUseCaseType {
    
    let networkService: NetworkServiceType
    
    func fetchWeatherForecast(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponseModel, Error> {
        let resource = WeatherForecastResource(latitude: latitude, longitude: longitude)
        return networkService.request(resource: resource, for: WeatherResponseModel.self)
            .eraseToAnyPublisher()
    }
}
