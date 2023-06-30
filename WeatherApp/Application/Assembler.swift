//
//  Assembler.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation

protocol Assembler: AnyObject {
    
    // MARK: Application
    func resolve() -> NetworkServiceType
    func resolve() -> LocationManagerType
    
    // MARK: - UseCases
    func resolve() -> FetchWeatherForecastUseCase
    func resolve() -> FetchLocationUseCaseType
    
    // MARK: - Presentation
    func resolve() -> MainViewModel
    func resolve() -> MainView
}

class DefaultAssembler: Assembler {
    
    // MARK: - Properties
    let locationManager: LocationManagerType
    let networkService: NetworkServiceType
    
    // MARK: - Construct
    init() {
        self.networkService = NetworkService(session: .default)
        self.locationManager = LocationManager()
    }
    
    // MARK: Application
    func resolve() -> NetworkServiceType {
        return networkService
    }
    
    func resolve() -> LocationManagerType {
        return locationManager
    }
    
    // MARK: - UseCases
    func resolve() -> FetchWeatherForecastUseCase {
        return FetchWeatherForecastUseCase(networkService: resolve())
    }
    
    func resolve() -> FetchLocationUseCaseType {
        return FetchLocationUseCase(locationManager: resolve())
    }
    
    // MARK: - Presentation
    func resolve() -> MainViewModel {
        return MainViewModel(fetchWeatherUseCase: resolve(), fetchLocationUseCase: resolve())
    }
    func resolve() -> MainView {
        return MainView(viewModel: resolve())
    }
    
}
