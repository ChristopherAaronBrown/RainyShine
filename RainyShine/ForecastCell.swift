//
//  ForecastCell.swift
//  RainyShine
//
//  Created by Chris Brown on 1/11/17.
//  Copyright © 2017 Chris Brown. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    func configureCell(forecast: Forecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        weatherIcon.image = UIImage(named: "\(forecast.condition) Mini")
        dayLabel.text = dateFormatter.string(from: forecast.date)
        weatherLabel.text = forecast.condition
        highTempLabel.text = "\(forecast.highTemp)°"
        lowTempLabel.text = "\(forecast.lowTemp)°"
    }
}
