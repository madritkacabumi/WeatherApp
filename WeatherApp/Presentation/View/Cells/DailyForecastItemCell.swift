//
//  DailyForecastItemCell.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 30.06.23.
//

import SwiftUI

struct DailyForecastItemCell: View {
    
    // MARK: - Properties
    let entity: DailyForecastCellEntity
    
    // MARK: - Body
    var body: some View {
        
        HStack(spacing: 20) {
            
            Text(entity.dateDisplayTitle)
                .foregroundColor(AppStyle.ColorResources.titleTextColor)
                .font(.title3)
                .fontDesign(.rounded)
                .frame(alignment: .center)
            
            Spacer()
            
            HStack {
                AppStyle.ImageResources
                    .sunMin
                    .foregroundColor(AppStyle.ColorResources.white)
                
                Text(entity.minTemperature)
                    .foregroundColor(AppStyle.ColorResources.titleTextColor)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .frame(alignment: .center)
            }
            
            Spacer()
            
            HStack(spacing: 5) {
                
                AppStyle.ImageResources
                    .sun
                    .foregroundColor(AppStyle.ColorResources.white)
                
                Text(entity.maxTemperature)
                    .foregroundColor(AppStyle.ColorResources.titleTextColor)
                    .font(.title3)
                    .fontDesign(.rounded)
                    .frame(alignment: .center)
            }

        }.listRowBackground(AppStyle.ColorResources.blackOpaque40Color)
    }
}

struct DailyForecastItemCell_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            DailyForecastItemCell(entity: .init(dateDisplayTitle: "Sat", minTemperature: "13°C", maxTemperature: "25°C"))
        }.foregroundColor(.black)
            .background(Color.black)
    }
}
