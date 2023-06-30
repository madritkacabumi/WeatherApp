//
//  ContentView.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 28.06.23.
//

import SwiftUI
import Combine

struct MainView: View {
    
    // MARK: - Properties
    let viewModel: MainViewModel
    let disposeBag = DisposeBag()
    
    @ObservedObject var output: MainViewModel.Output
    
    // MARK: - Construct
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        self.output = viewModel.transform(.init(), disposeBag: disposeBag)
    }
    
    var body: some View {
        
        ZStack {
            
            // Setup Background
            AppStyle.ImageResources.weatherBackground
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            AppStyle.ColorResources.blackOpaque40Color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if output.errorMessage != nil {
                    // TODO: Handle Error, Ideally show a view with a button to retry the operation
                } else if output.isLoading { // Check Loading
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppStyle.ColorResources.white))
                        .scaleEffect(2.0)
                } else { // render items view
                    listView
                        .transition(.opacity)
                }
            }.animation(.easeInOut(duration: 0.5), value: output.isLoading)
                
        }
    }
    
    var listView: some View {
        
        List {
            
            if let todayForecastEntity = output.todayForecastEntity {
                TodayForecastListViewCell(entity: todayForecastEntity)
                    .listRowInsets(EdgeInsets())
            }
            
            // Daily forecast
            Section("7 Days forecast") {
                ForEach(output.dailyForecast, id: \.self) { entity in
                    DailyForecastItemCell(entity: entity)
                }
            }.foregroundColor(.white)
            .backgroundStyle(.ultraThinMaterial)
            .cornerRadius(10)
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .padding(.bottom, 5)
        .scrollContentBackground(.hidden)
    }
}

