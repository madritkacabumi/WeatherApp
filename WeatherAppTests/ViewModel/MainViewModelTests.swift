//
//  MainViewModelTests.swift
//  WeatherAppTests
//
//  Created by Madrit Kacabumi on 30.06.23.
//

@testable import WeatherApp
import XCTest
import Combine

class MainViewModelTests: XCTestCase {
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    private var viewModel: MainViewModel!
    
    // MARK: Mock
    private var fetchWeatherUseCase: FetchWeatherForecastUseCaseMock!
    private var fetchLocationUseCase: FetchLocationUseCaseMock!
    
    // MARK: I/O
    private var input: MainViewModel.Input!
    private var output: MainViewModel.Output!
    
    override func setUp() {
        super.setUp()
        
        fetchWeatherUseCase = FetchWeatherForecastUseCaseMock()
        fetchLocationUseCase = FetchLocationUseCaseMock()
        
        viewModel = MainViewModel(fetchWeatherUseCase: fetchWeatherUseCase, fetchLocationUseCase: fetchLocationUseCase)
        self.input = MainViewModel.Input()
        self.output = viewModel.transform(input, disposeBag: disposeBag)
    }
    
    func test_CountersTodayForecast() throws {
        _ = try triggeredPublisher(output.$todayForecastEntity.filter { $0 != nil }, trigger: {
            self.fetchLocationUseCase.trigger()
        })
        
        XCTAssertTrue(self.fetchWeatherUseCase.testCounter.count == 1)
        XCTAssertTrue(self.fetchLocationUseCase.testCounter.count == 1)
        XCTAssertNil(self.output.errorMessage)
    }
    
    func test_CountersDailyForecast() throws {
        _ = try triggeredPublisher(output.$dailyForecast.dropFirst(), trigger: {
            self.fetchLocationUseCase.trigger()
        })
        
        XCTAssertTrue(self.fetchWeatherUseCase.testCounter.count == 1)
        XCTAssertTrue(self.fetchLocationUseCase.testCounter.count == 1)
        XCTAssertNil(self.output.errorMessage)
    }
}
