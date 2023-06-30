//
//  FetchLocationUseCase.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Combine

protocol FetchLocationUseCaseType {
    func getLocation() -> AnyPublisher<LocationCoordinates?, Never>
}

struct FetchLocationUseCase: FetchLocationUseCaseType {
    
    let locationManager: LocationManagerType
    
    func getLocation() -> AnyPublisher<LocationCoordinates?, Never> {
        return locationManager.location.eraseToAnyPublisher()
    }
}
