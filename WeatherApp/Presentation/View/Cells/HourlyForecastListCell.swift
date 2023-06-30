//
//  HourlyForecastListCell.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 30.06.23.
//

import SwiftUI

struct HourlyForecastListCell: View {
    
    let entity: HourlyCellEntity
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Text(entity.hour)
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .font(.subheadline)
                .fontDesign(.rounded)
                .frame(alignment: .center)
            
            (entity.isDay ? AppStyle.ImageResources.sun : AppStyle.ImageResources.moon)
                .foregroundColor(AppStyle.ColorResources.white)
            
            Text(entity.temperature)
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .font(.subheadline)
                .fontDesign(.rounded)
                .frame(alignment: .center)
        }
    }
    
}

struct HourlyForecastListCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            HourlyForecastListCell(entity: HourlyCellEntity(hour: "10:00", isDay: true, temperature: "25°C"))
        }.foregroundColor(.black)
            .background(Color.black)
    }
}
