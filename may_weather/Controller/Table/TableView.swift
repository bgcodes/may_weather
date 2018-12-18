//
//  TableView.swift
//  may_weather
//
//  Created by Grzegorz Bogdan on 18/12/2018.
//  Copyright © 2018 Grzegorz Bogdan. All rights reserved.
//

import UIKit

class TableView: UITableViewController, UISplitViewControllerDelegate {

    static var Weathers = [Weather]()
    static var checker = true
    
    private func loadStartData(){
        createNewWeather(location: "Berlin")
        createNewWeather(location: "London")
        createNewWeather(location: "New York")
        TableView.checker = false
    }
    
    public func createNewWeather(location: String) {
        LocationService.getDataFromAPI(cityName: location, completion: self.addWeather)
    }
    
    private func addWeather(weather: Weather) -> Void {
        print("Added: ", weather.locationName ?? "NIL")
        TableView.Weathers.append(weather)
        print("Weathers.count:", TableView.Weathers.count)
        self.reload()
    }
    
    private func removeWeather(weatherIndex: Int){
        print("Removed weather with number: ", weatherIndex)
        TableView.Weathers.remove(at: weatherIndex)
        print("Weathers.count:", TableView.Weathers.count)
        self.reload()
    }
    
    public func reload(){
        print("reloaded()")
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(TableView.checker == true) {
            splitViewController?.delegate = self
            loadStartData()
        }
        navigationItem.leftBarButtonItem = self.editButtonItem
        let searchNavigateButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToSearchView(_:)))
        navigationItem.rightBarButtonItem = searchNavigateButton
      
        print("yo: ", TableView.Weathers.count)
        self.reload()
    }

    @objc func navigateToSearchView(_ sender: Any) {
        performSegue(withIdentifier: "SegueMainToSearch", sender: self)
    }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableView.Weathers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell else{
            fatalError("The dequeued cell is not an instance of TableViewCell")
        }

        let weather = TableView.Weathers[indexPath.row]
        cell.CellImage.image = UIImage(named: (weather.daily.data[0].icon))
        cell.CellTownLabel.text = weather.locationName
        cell.CellTemperatureLabel.text = String(format: "%.2f", weather.currently.temperature) + " C"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SingleView.setWeather(weather: TableView.Weathers[indexPath.row])
        performSegue(withIdentifier: "SegueMainToSingle", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.removeWeather(weatherIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
