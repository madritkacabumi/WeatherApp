//
//  TodayForecastListViewCell.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import SwiftUI

struct TodayForecastListViewCell: View {
    
    let entity: TodayDetailForecastCellEntity
    
    var body: some View {
        
        VStack {
            
            // Location Name
            Text(entity.location)
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .font(.title)
                .fontDesign(.rounded)
            
            // Location Temp
            Text(entity.currentTemperature)
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .fontDesign(.monospaced)
                .bold()
                .font(.system(size: 45))
            
            // Container for min/max and sunrise/sunset
            extraAttributes
            
            // Hourly forecast
            hourlyForecast
            
        }.listRowBackground(Color.clear)
    }
    
    var extraAttributes: some View {
        
        VStack(spacing: 7) {
            
            // Min/Max
            HStack(spacing: 5) {
                
                Text(entity.minTemp)
                    .foregroundColor(AppStyle.ColorResources.titleTextColor)
                    .font(.subheadline)
                
                Text(entity.maxTemp)
                    .foregroundColor(AppStyle.ColorResources.titleTextColor)
                    .font(.subheadline)
                
            }
            
            // Sunrise/ Sunset
            HStack(spacing: 20) {
                
                // Sunrise
                HStack(spacing: 5) {
                    
                    AppStyle.ImageResources
                        .sunrise
                        .foregroundColor(AppStyle.ColorResources.white)
                    
                    Text(entity.sunrise)
                        .foregroundColor(AppStyle.ColorResources.titleTextColor)
                        .font(.subheadline)
                }
                
                // Sunset
                HStack(spacing: 5) {
                    
                    AppStyle.ImageResources
                        .sunset
                        .foregroundColor(AppStyle.ColorResources.white)
                    
                    Text(entity.sunset)
                        .foregroundColor(AppStyle.ColorResources.titleTextColor)
                        .font(.subheadline)
                }
            }
        }
    }
    
    var hourlyForecast: some View {
        
        VStack {
            Text("Hourly forecast".uppercased())
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 20)
            
            VStack {
                ScrollView(.horizontal) {
                    
                    LazyHStack(spacing: 15) {
                        ForEach(entity.hourlyForecast, id: \.self) { entity in
                            HourlyForecastListCell(entity: entity)
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    
                }.scrollIndicators(.hidden)
            }
            .backgroundStyle(.ultraThinMaterial)
            .background(AppStyle.ColorResources.blackOpaque40Color)
            .cornerRadius(10)
        }
    }
}

struct TodayForecastListViewCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            TodayForecastListViewCell(entity: TodayDetailForecastCellEntity(location: "New York", currentTemperature: "25°C", windSpeed: "10 km/h", hourlyForecast: [
                HourlyCellEntity(hour: "10:00", isDay: true, temperature: "25°C"),
                HourlyCellEntity(hour: "11:00", isDay: true, temperature: "26°C"),
                HourlyCellEntity(hour: "12:00", isDay: true, temperature: "27°C")
            ], sunrise: "07:30", sunset: "22:00", minTemp: "Min: 16°C", maxTemp: "Max: 19°C"))
        }.foregroundColor(.black)
            .background(Color.black)

    }
}
