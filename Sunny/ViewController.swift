//
//  ViewController.swift
//  Sunny
//
//  Created by Peter Iontsev on 2/25/18.
//  Copyright © 2018 Peter Iontsev. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    fileprivate var currentWeather = [Weather]()
    
    var locationManager: CLLocationManager!
    
    var lat: Double = 35.7204
    var long: Double = 139.8360
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        lat = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude
        
        Alamofire.request("https://api.darksky.net/forecast/91c19e8ad457ea5491436fe424b8cdc7/\(lat),\(long)", method: .get).responseJSON { response in
            guard response.result.isSuccess else {
                print("\(String(describing: response.result.error))")
                return
            }
            guard let jsonDictionary = response.result.value as? [String: Any] else {
                print("No dictionary to transform")
                return
            }
            guard let currentWeatherDictionary = jsonDictionary["currently"] as? [String: Any] else {
                print("No dictionary to transform")
                return
            }
            let currentWeather = Weather(weatherDictionary: currentWeatherDictionary)
            DispatchQueue.main.async {
                self.summaryLabel.text = currentWeather.summary
                self.tempLabel.text = String(currentWeather.temperature ?? 0) + "℃"
                self.iconLabel.text = currentWeather.icon
            }
        }
        
        geocode(latitude: lat, longitude: long) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            DispatchQueue.main.async {
                print("city:", placemark.locality ?? "")
                self.cityLabel.text = placemark.locality
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}


























    

