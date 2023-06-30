//
//  Style.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import SwiftUI

struct AppStyle {
    
    struct ImageResources {
        static var weatherBackground: Image { Image("mainPageBackground") }
        static var sunrise: Image { Image(systemName: "sunrise") }
        static var sunset: Image { Image(systemName: "sunset") }
        static var sunMin: Image { Image(systemName: "sun.min.fill") }
        static var sun: Image { Image(systemName: "sun.max.fill") }
        static var moon: Image { Image(systemName: "moon.fill") }
    }
    
    struct ColorResources {
        static let titleTextColor = Color(red: 0.9569, green: 0.9569, blue: 0.9569)
        static let blackOpaque80Color = Color.black.opacity(0.8)
        static let blackOpaque40Color = Color.black.opacity(0.4)
        static let white = Color.white
    }
}
