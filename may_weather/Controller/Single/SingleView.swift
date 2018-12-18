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
    
    static var weather: Weather?
    static var dayIndex: Int?
    static var dayRange: (ClosedRange<Int>)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreviousButton.setTitleColor(UIColor.gray, for: .disabled)
        NextButton.setTitleColor(UIColor.gray, for: .disabled)
    
        let mapNavigateButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToMapView(_:)))
        navigationItem.rightBarButtonItem = mapNavigateButton
    }
    
    @objc func navigateToMapView(_ sender: Any){
        MapViewController.changeLocation(latitude: (SingleView.weather?.latitude)!, longitude: (SingleView.weather?.longitude)!, locationName: (SingleView.weather?.locationName)!)
        performSegue(withIdentifier: "SegueSingleToMap", sender: self)
    }

    static func setWeather(weather: Weather){
        print("Received data for city called: ", weather.locationName ?? "")

        if (weather.daily.data.count > 0) {
            self.weather = weather
            self.dayRange = 0...(weather.daily.data.count - 1)
            self.dayIndex = 0
        } else{
            print("API_ERROR: less than 0 days")
        }
    }
    
    func updateView() {
        if SingleView.dayRange!.contains(SingleView.dayIndex!){
            DispatchQueue.main.async {
                let today = SingleView.weather?.daily.data[SingleView.dayIndex!]
                self.TownLabel.text = SingleView.weather?.locationName
            
                self.DayLabel.text = DateParser.parseDate(unixTimestamp: (today?.time)!)
                
                self.IconImageView.image = UIImage(named: (today?.icon)!)
                self.MinTemperatureLabel.text = String(format:"%.1f C", (today?.temperatureMin)!)
                self.MaxTemperatureLabel.text = String(format:"%.1f C", (today?.temperatureMax)!)
                self.PressureLabel.text = String(format:"%.1f hPa", (today?.pressure)!)
                
                self.PrecLabel.text = String(format:"%.0f", ((today?.precipProbability)! * 100)) + " %"
                
                self.WindSpeedLabel.text = String(format:"%.2f m/s", (today?.windSpeed)!)
                self.WindDirLabel.text = String(format:"%.2f", (today?.windBearing)!)
                
                self.PreviousButton.isEnabled = (1...(SingleView.dayRange!.upperBound)).contains(SingleView.dayIndex!)
                self.NextButton.isEnabled = (0..<(SingleView.dayRange!.upperBound)).contains(SingleView.dayIndex!)
                
            }
        }
    }
    
    @IBAction func prevButtonClicked(_ sender: UIButton) {
        print("PrevButton()")
        SingleView.dayIndex = SingleView.dayIndex! - 1
        self.updateView()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        print("NextButton()")
        SingleView.dayIndex = SingleView.dayIndex! + 1
        self.updateView()
    }
}

