//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation
import Combine

struct TodayDetailForecastCellEntity {
    let location: String
    let currentTemperature: String
    var hourlyForecast: [HourlyCellEntity] = []
    var sunrise: String = ""
    var sunset: String = ""
    var minTemp: String = ""
    var maxTemp: String = ""
}

struct HourlyCellEntity: Hashable {
    let hour: String
    let isDay: Bool
    let temperature: String
}

struct DailyForecastCellEntity: Hashable {
    let dateDisplayTitle: String
    let minTemperature: String
    let maxTemperature: String
}

struct MainViewModel {
    
    // MARK: - Properties
    let fetchWeatherUseCase: FetchWeatherForecastUseCaseType
    let fetchLocationUseCase: FetchLocationUseCaseType
    
    // MARK: - I/O
    struct Input {
        // No Input needed
    }
    
    class Output: ObservableObject {
        fileprivate var currentCoordinates: LocationCoordinates?
        
        @Published var errorMessage: String? = nil
        @Published var isLoading: Bool = true
        @Published var todayForecastEntity: TodayDetailForecastCellEntity? = nil
        @Published var dailyForecast: [DailyForecastCellEntity] = []
    }
    
    // MARK: - Transform
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        // get location as a trigger
        fetchLocationUseCase.getLocation()
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .handleValue(callback: { coordinates in
                output.currentCoordinates = coordinates
                output.isLoading = true
            })
            .flatMap { coordinate -> AnyPublisher<Void, Never> in
                
                // fetch weather forecast
                return fetchWeatherUseCase.fetchWeatherForecast(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    .handleError(callback: { error in
                        output.errorMessage = error.localizedDescription
                    })
                    .receive(on: DispatchQueue.main)
                    .handleValue(callback: { forecast in
                        output.todayForecastEntity = mapTodayForecast(forecast: forecast, coordinates: output.currentCoordinates)
                        output.dailyForecast = mapDailyForecasts(forecast: forecast)
                    })
                    .map { _ in () }
                    .catch { error in
                        return Just(())
                    }.setFailureType(to: Never.self)
                    .eraseToAnyPublisher()
                
                }
            .receive(on: DispatchQueue.main)
            .handleValue(callback: { _ in
                    output.isLoading = false
                }).sink()
        
            .store(in: disposeBag)
        
        return output
    }
    
    private func mapTodayForecast(forecast: WeatherResponseModel, coordinates: LocationCoordinates?) -> TodayDetailForecastCellEntity {
        
        var todayForecast = TodayDetailForecastCellEntity(location: coordinates?.locationName ?? "",
                                                          currentTemperature: forecast.currentWeather.temperature.formattedTemperature,
                                                          hourlyForecast: [])
        
        let currentDay = forecast.currentWeather.time.get(.day)
        let currentHour = forecast.currentWeather.time.get(.hour)
        
        var hourlyForecasts = [HourlyCellEntity]()
        
        // get the current sunrise and sunset from the array of time and data
        guard let indexInDailyArray = forecast.daily.time.firstIndex(where:  { $0.get(.day) == currentDay }) else {
            return todayForecast
        }
        
        let sunrise = forecast.daily.sunrise[indexInDailyArray]
        let sunset = forecast.daily.sunset[indexInDailyArray]
        
        // populate hourly forecast array
        for hourlyDateSet in forecast.hourly.time.enumerated() {
            
            guard hourlyDateSet.element.get(.day) == currentDay && hourlyDateSet.element.get(.hour) >= currentHour else {
                continue
            }
            let hourTitle = DateFormatterUtils.dateToString(date: hourlyDateSet.element, format: "HH")
            let isDay = hourlyDateSet.element >= sunrise && hourlyDateSet.element < sunset
            let temperature = forecast.hourly.temperature[hourlyDateSet.offset].formattedTemperature
            let hourCellEntity = HourlyCellEntity(hour: hourTitle, isDay: isDay, temperature: temperature)
            hourlyForecasts.append(hourCellEntity)
        }
        
        // update optional data
        todayForecast.hourlyForecast = hourlyForecasts
        todayForecast.sunrise = DateFormatterUtils.dateToString(date: sunrise, format: "HH:mm")
        todayForecast.sunset = DateFormatterUtils.dateToString(date: sunset, format: "HH:mm")
        todayForecast.minTemp = "Min: " + forecast.daily.minTemp[indexInDailyArray].formattedTemperature
        todayForecast.maxTemp = "Max: " + forecast.daily.maxTemp[indexInDailyArray].formattedTemperature
        
        return todayForecast
    }
    
    private func mapDailyForecasts(forecast: WeatherResponseModel) -> [DailyForecastCellEntity] {
        var forecasts = [DailyForecastCellEntity]()
        for dailyDateSet in forecast.daily.time.enumerated() {
            
            let isToday = dailyDateSet.element.get(.day) == Date().get(.day)
            let dateDisplayTitle = isToday ? "Today" : DateFormatterUtils.dateToString(date: dailyDateSet.element, format: "E")
            
            let dailyForecast = DailyForecastCellEntity(dateDisplayTitle: dateDisplayTitle,
                                                        minTemperature: forecast.daily.minTemp[dailyDateSet.offset].formattedTemperature,
                                                        maxTemperature: forecast.daily.maxTemp[dailyDateSet.offset].formattedTemperature)
            forecasts.append(dailyForecast)
        }
        return forecasts
    }
}

fileprivate extension Float {
    
    var formattedTemperature: String {
        return String(format: "%.f", self) + "°C"
    }
}


