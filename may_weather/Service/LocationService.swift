//
//  DataPuller.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 01/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService {

    static let baseURL = "https://api.darksky.net/forecast/965b5e1f6514ee3a66017c215d128973/"
    static let flags = "?exclude=monthly,minutely,hourly,alerts,offset,flags&units=si"
    
    static func getDataFromAPI(cityName: String, completion: @escaping (Weather) -> Void) {
        getCoordinatesFromLocationName(locationName: cityName) { (coords) in
            let JSON_URL = baseURL + coords + flags
            //print("getDataFromAPI() -> JSON_URL: ",JSON_URL)
            guard let url = URL(string: JSON_URL) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                guard let data = data else {return}
                
                do {
                    var weather = try JSONDecoder().decode(Weather.self, from: data)
                    weather.locationName = cityName
                    completion(weather)
                } catch let jsonError {
                    print("jsonError:",jsonError)
                }
                }.resume()
        }
    }
    
    static func getCoordinatesFromLocationName(locationName: String, completion: @escaping (String) -> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let longitude = String(location.coordinate.longitude)
                    let latitude = String(location.coordinate.latitude)
                    let coordinateString = latitude + "," + longitude
                    completion(coordinateString)
                }
            } else {print(error!)}
        }
    }
    
    
}
