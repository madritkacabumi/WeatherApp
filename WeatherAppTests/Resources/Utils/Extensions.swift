//
//  Extensions.swift
//  WeatherAppTests
//
//  Created by Madrit Kacabumi on 30.06.23.
//

import Foundation
import Combine
import XCTest

extension XCTestCase {
    
    func triggeredPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        trigger: (() -> Void)? = nil
    ) throws -> Bool {
        
        let expectation = self.expectation(description: "Triggering publisher")
        var fullfilled: Bool = false
        var triggered = false
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .failure:
                        triggered = true
                    case .finished:
                        break
                }
                triggered = true
                if !fullfilled {
                    expectation.fulfill()
                    fullfilled = true
                }
            },
            receiveValue: { value in
                
                if !fullfilled {
                    triggered = true
                    expectation.fulfill()
                    fullfilled = true
                }
            }
        )
        trigger?()
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            triggered,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return unwrappedResult
    }
    
}
