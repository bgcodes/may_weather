//
//  SearchView.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 18/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var AcceptButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    private var foundLocations = [String]()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        reload()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func reload(){
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchCell else{
            fatalError("The dequeued cell is not an instance of SearchCell")
        }
        
        cell.LocationLabel.text = foundLocations[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tv = TableView()
        tv.createNewWeather(location: foundLocations[indexPath.row])
        tv.reload()
        
        performSegue(withIdentifier: "SegueSearchToMain", sender: self)
    }

    @IBAction func AcceptButtonClicked(_ sender: Any) {
        if let text = TextField.text {
            foundLocations.append(text)
            TextField.text = ""
            self.reload()
        } else {
            print("TextField: empty")
        }
    }
    
    @IBAction func CancelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "SegueSearchToMain", sender: self)
    }
}
