//
//  MapView.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 18/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var TitleItem: UINavigationItem!
    
    static var latitude: Double?
    static var longitude: Double?
    static var locationName: String?
    
    public static func changeLocation(latitude: Double, longitude: Double, locationName: String) {
        MapViewController.locationName = locationName
        MapViewController.latitude = latitude
        MapViewController.longitude = longitude
        print("Coordinates caught: ", latitude, ", ", longitude)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: MapViewController.latitude ?? 50.0, longitude: MapViewController.longitude ?? 20.0)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        let pin = MKPointAnnotation()
        
        pin.coordinate = location
       
        DispatchQueue.main.async {
            self.TitleItem.title = MapViewController.locationName
            self.MapView.setRegion(region, animated: true)
            self.MapView.addAnnotation(pin)
        }
    }
    
    
    


}
