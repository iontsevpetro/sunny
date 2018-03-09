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
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()
            lat = (locationManager.location?.coordinate.latitude)!
            long = (locationManager.location?.coordinate.longitude)!
        }
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
            }
        }
        print(locationManager.location?.coordinate.latitude ?? 0.0)
        print(locationManager.location?.coordinate.longitude ?? 0.0)
        
        geocode(latitude: lat, longitude: long) { placemark, error in
            guard let placemark = placemark, error == nil else { return }
            // you should always update your UI in the main thread
            DispatchQueue.main.async {
                //  update UI here
                print("city:",     placemark.locality ?? "")
//                print("address1:", placemark.thoroughfare ?? "")
//                print("address2:", placemark.subThoroughfare ?? "")
//                print("city:",     placemark.locality ?? "")
//                print("state:",    placemark.administrativeArea ?? "")
//                print("zip code:", placemark.postalCode ?? "")
//                print("country:",  placemark.country ?? "")
                self.cityLabel.text = placemark.locality
            }
        }
    }
}


























    

