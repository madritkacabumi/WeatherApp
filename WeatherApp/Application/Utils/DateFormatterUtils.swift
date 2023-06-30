//
//  DateFormatterUtils.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation

struct DateFormatterUtils {
    
    static func dateFromString(dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    static func dateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension DateFormatterUtils {
    
    static var invalidParsingDate: Error {
        // TODO: Create a better error to rapresent failure in parsing dates
        return NSError(domain: "", code: -555, userInfo: nil)
    }
}

extension Date {

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
