//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 28.06.23.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    let assembler: Assembler
    
    init() {
        self.assembler = DefaultAssembler()
    }
    
    var body: some Scene {
        WindowGroup {
            self.assembler.resolve() as MainView
        }
    }
}
