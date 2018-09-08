//
//  WeatherUndergroundService.swift
//  RainyShine
//
//  Created by Chris Brown on 4/20/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

class WeatherUndergroundService: WeatherService {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func createCurrentWeatherURL(location: Location) -> String {
        return ""
    }
    
    private func createForecastURL(location: Location, count: Int) -> String {
        return ""
    }
    
    func getWeather(location: Location, callback: @escaping WeatherCallback) {
        
    }
    
}
