//
//  OpenWeatherMapService.swift
//  RainyShine
//
//  Created by Chris Brown on 1/11/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import Alamofire

class OpenWeatherMapService: WeatherService {

    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }

    private func createCurrentWeatherURL(location: Location) -> String {
        return "http://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(self.apiKey)"
    }
    
    private func createForecastURL(location: Location, count: Int) -> String {
        return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(location.latitude)&lon=\(location.longitude)&cnt=\(count)&mode=json&appid=\(self.apiKey)"
    }
    
    func getWeather(location: Location, callback: @escaping WeatherCallback) {
        let currentWeatherURL = createCurrentWeatherURL(location: location)
        let currentForecastURL = createForecastURL(location: location, count: 16)
        
        Alamofire.request(currentWeatherURL).responseJSON { response in
            let result = response.result
            
            // CurrentWeather variables
            var location = ""
            var currentCondition = ""
            var currentTemp = 0.0
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    location = name.capitalized
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        currentCondition = main.capitalized
                    }
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    if let temp = main["temp"] as? Double {
                        let kelvinToFahrenheit = (temp * (9/5) - 459.67)
                        let kelvinToFahrenheitRounded = Double(round(10 * kelvinToFahrenheit) / 10)
                        currentTemp = kelvinToFahrenheitRounded
                    }
                }
            }
            
            let currentWeather = CurrentWeather(date: Date(), location: location, currentCondition: currentCondition, currentTemp: currentTemp)
            
            Alamofire.request(currentForecastURL).responseJSON { response in
                let result = response.result
                
                var forecasts = [Forecast]()
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for weatherDict in list {
                            
                            // Forecast varbles
                            var date: Date? = nil
                            var condition = ""
                            var highTemp = 0.0
                            var lowTemp = 0.0
                            
                            if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
                                if let min = temp["min"] as? Double {
                                    let kelvinToFahrenheit = (min * (9/5) - 459.67)
                                    let kelvinToFahrenheitRounded = Double(round(10 * kelvinToFahrenheit) / 10)
                                    lowTemp = kelvinToFahrenheitRounded
                                }
                                if let max = temp["max"] as? Double {
                                    let kelvinToFahrenheit = (max * (9/5) - 459.67)
                                    let kelvinToFahrenheitRounded = Double(round(10 * kelvinToFahrenheit) / 10)
                                    highTemp = kelvinToFahrenheitRounded
                                }
                            }
                            
                            if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
                                if let main = weather[0]["main"] as? String {
                                    condition = main
                                }
                            }
                            
                            if let dt = weatherDict["dt"] as? Double {
                                date = Date(timeIntervalSince1970: dt)
                            }
                            
                            let forecast = Forecast(date: date!, condition: condition, highTemp: highTemp, lowTemp: lowTemp)
                            forecasts.append(forecast)
                            
                        }
                        forecasts.remove(at: 0)
                    }
                }
                callback(currentWeather, forecasts)
            } // Forecast callback
        } // CurrentWeather callback
    }
    
}
