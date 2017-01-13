//
//  WeatherService.swift
//  RainyShine
//
//  Created by Chris Brown on 1/11/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

typealias WeatherCallback = (CurrentWeather,[Forecast]) -> ()

protocol WeatherService {
    func getWeather(location: Location, callback: @escaping WeatherCallback)
}
