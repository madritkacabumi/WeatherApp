//
//  FetchLocationUseCaseMock.swift
//  WeatherAppTests
//
//  Created by Madrit Kacabumi on 30.06.23.
//

import Combine
@testable import WeatherApp
import Foundation

struct FetchLocationUseCaseMock: FetchLocationUseCaseType {
    
    let testCounter = TestCounter()
    private let locationTrigger = PassthroughSubject<LocationCoordinates?, Never>()
    
    
    func getLocation() -> AnyPublisher<LocationCoordinates?, Never> {
        testCounter.increment()
        return locationTrigger
            .eraseToAnyPublisher()
    }
    
    func trigger() {
        locationTrigger.send(LocationCoordinates(locationName: "Location 1", latitude: 53.619653, longitude: 10.079969))
    }
}
