//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import SwiftUI
import Combine

struct LocationCoordinates: Decodable {
    let locationName: String
    let latitude: Double
    let longitude: Double
}

protocol LocationManagerType {
    var location: CurrentValueSubject<LocationCoordinates?, Never> { get }
}

class LocationManager: LocationManagerType {
    
    // MARK: - Constant
    private static let locationInterval = TimeInterval(10)
    
    // MARK: - Properties
    private let appDisposeBag = DisposeBag()
    private let timerDisposeBag = DisposeBag()
    private var timerStarted: Bool = false
    private let simulatedData: [LocationCoordinates]
    private var interruptionDate: Double?
    private var index: Int = .zero
    
    let location: CurrentValueSubject<LocationCoordinates?, Never> = CurrentValueSubject(nil)
    
    // MARK: - Construct
    init() {
        simulatedData = Bundle.main.decodeLocalJsonFile(jsonFileName: "simulated_locations") ?? []
        bindToApplicationLifecycle()
    }
    
    private func bindToApplicationLifecycle() {
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .filter { _ in self.timerStarted }
            .sink { [weak self] _ in
                self?.stopTimer()
            }.store(in: appDisposeBag)
        
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .filter { _ in !self.timerStarted }
            .sink { [weak self] _ in
                self?.startTimer()
            }.store(in: appDisposeBag)
    }
    
    // MARK: - Start/Stop Timer
    private func startTimer() {
        
        guard let interruptionDate = interruptionDate else  {
            setupTimer(.zero)
            return
        }
        
        let diffSinceInterrupted = Date().timeIntervalSinceReferenceDate - interruptionDate

        let progressedCycles = diffSinceInterrupted / Self.locationInterval
        let remainedSeconds = (progressedCycles - progressedCycles.rounded(.down)) * Self.locationInterval
        index = (Int(progressedCycles.rounded(.down)) + index) % simulatedData.count
        
        self.interruptionDate = nil
        broadcastLocation(increment: false)
        
        setupTimer(Int(Self.locationInterval - remainedSeconds))
    }
    
    private func setupTimer(_ after: Int) {
        Just(())
            .delay(for: .init(TimeInterval(after)), scheduler: RunLoop.current)
            .handleValue(callback: { [weak self] _ in
                print("after", after)
                self?.broadcastLocation(increment: true)
            }).flatMap {
                Timer.publish(every: Self.locationInterval, tolerance: 0.1, on: .main, in: .common)
                    .autoconnect()
            }.sink { [weak self] _ in
                self?.broadcastLocation(increment: true)
            }.store(in: timerDisposeBag)
        self.timerStarted = true
    }
    
    /// Publish the coordinate at the given time
    /// - Parameter increment: decide whenever we should increment the index to fetch the simulated data
    private func broadcastLocation(increment: Bool) {
        
        guard increment else {
            print("from interruption", index)
            self.location.send(self.simulatedData[self.index])
            return
        }
        
        self.index += 1
        if self.index >= simulatedData.count {
            self.index = .zero
        }
        print("from timmer", index)
        self.location.send(self.simulatedData[self.index])
    }
    
    private func stopTimer() {
        self.interruptionDate = Date().timeIntervalSinceReferenceDate
        timerDisposeBag.clear()
        self.timerStarted = false
    }
}

