//
//  Forecast.swift
//  RainyShine
//
//  Created by Chris Brown on 1/11/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Foundation

struct Forecast {
    let date: Date
    let condition: String
    let highTemp: Double
    let lowTemp: Double
    
    init(date: Date, condition: String, highTemp: Double, lowTemp: Double) {
        self.date = date
        self.condition = condition
        self.highTemp = highTemp
        self.lowTemp = lowTemp
    }
}
