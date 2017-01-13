//
//  CurrentWeather.swift
//  RainyShine
//
//  Created by Chris Brown on 1/10/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let date: Date
    let location: String
    let currentCondition: String
    let currentTemp: Double
    
    init(date: Date, location: String, currentCondition: String, currentTemp: Double) {
        self.date = date
        self.location = location
        self.currentCondition = currentCondition
        self.currentTemp = currentTemp
    }
}
