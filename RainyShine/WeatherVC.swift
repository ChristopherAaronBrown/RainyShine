//
//  WeatherVC.swift
//  RainyShine
//
//  Created by Chris Brown on 1/10/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    let locationManager = CLLocationManager()
    let weatherService: WeatherService = OpenWeatherMapService(apiKey: OPEN_WEATHER_MAP_API_KEY)
    
    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
    }
    
    func updateWeather() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            let currentLocation = Location(latitude: locationManager.location!.coordinate.latitude,
                                           longitude: locationManager.location!.coordinate.longitude)
            weatherService.getWeather(location: currentLocation, callback: { currentWeather, forecasts  in
                self.updateCurrentWeather(currentWeather: currentWeather)
                self.forecasts = forecasts
                self.forecastTableView.reloadData()
            })
        } else {
            locationServicesNotAuthorized()
        }
    }
    
    func locationServicesNotAuthorized() {
        let alertController = UIAlertController(title: "Cannot determine location", message: "\(Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String) needs to use your location to determine weather conditions.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            updateWeather()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = forecastTableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastCell {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return ForecastCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func updateCurrentWeather(currentWeather: CurrentWeather) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        dateLabel.text = "Today, \(dateFormatter.string(from: currentWeather.date))"
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherLabel.text = currentWeather.currentCondition
        locationLabel.text = currentWeather.location
        currentWeatherImage.image = UIImage(named: currentWeather.currentCondition)
    }
}

