//
//  ViewController.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 29/11/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import UIKit
import CoreLocation

class SingleView: UIViewController {
   
    @IBOutlet weak var TownLabel: UILabel!
    @IBOutlet weak var DayLabel: UILabel!
    @IBOutlet weak var IconImageView: UIImageView!
    
    @IBOutlet weak var MinTemperatureLabel: UILabel!
    @IBOutlet weak var MaxTemperatureLabel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    
    @IBOutlet weak var PrecLabel: UILabel!
    @IBOutlet weak var WindSpeedLabel: UILabel!
    @IBOutlet weak var WindDirLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var PreviousButton: UIButton!
    
    private var weather: Weather?
    private var dayIndex: Int?
    private var dayRange: (ClosedRange<Int>)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreviousButton.setTitleColor(UIColor.gray, for: .disabled)
        NextButton.setTitleColor(UIColor.gray, for: .disabled)
        LocationService.getDataFromAPI(cityName: "Kraków", completion: self.updateWeather)
    }
    
    func updateWeather(weather: Weather){
        print("Received data for city called: ", weather.locationName ?? "")
        print("Number of days loaded: ",weather.daily.data.count)
        
        if (weather.daily.data.count > 0) {
            self.weather = weather
            self.dayRange = 0...(weather.daily.data.count - 1)
            self.dayIndex = 0

            self.updateView()
        }
        else{
            print("API_ERROR: less than 0 days")
        }
    }
    
    func updateView() {
        if self.dayRange!.contains(self.dayIndex!){
            DispatchQueue.main.async {
                // TODO: change that manual Date into correct timestamp translating
                let currentDate = Date()
                let activeDay = Calendar.current.date(byAdding: .day, value: self.dayIndex!, to: currentDate)
                
                let today = self.weather?.daily.data[self.dayIndex!]
                self.TownLabel.text = self.weather?.locationName
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.DayLabel.text = dateFormatter.string(from: activeDay!)
                
                self.IconImageView.image = UIImage(named: (today?.icon)!)
                self.MinTemperatureLabel.text = String(format:"%.1f C", (today?.temperatureMin)!)
                self.MaxTemperatureLabel.text = String(format:"%.1f C", (today?.temperatureMax)!)
                self.PressureLabel.text = String(format:"%.1f hPa", (today?.pressure)!)
                
                self.PrecLabel.text = String(format:"%.0f", ((today?.precipProbability)! * 100)) + " %"
                
                self.WindSpeedLabel.text = String(format:"%.2f m/s", (today?.windSpeed)!)
                self.WindDirLabel.text = String(format:"%.2f", (today?.windBearing)!)
                
                self.PreviousButton.isEnabled = (1...(self.dayRange!.upperBound)).contains(self.dayIndex!)
                self.NextButton.isEnabled = (0..<(self.dayRange!.upperBound)).contains(self.dayIndex!)
                
            }
        }
    }
    
    @IBAction func prevButtonClicked(_ sender: UIButton) {
        print("PrevButton()")
        self.dayIndex = self.dayIndex! - 1
        self.updateView()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        print("NextButton()")
        self.dayIndex = self.dayIndex! + 1
        self.updateView()
    }
}

