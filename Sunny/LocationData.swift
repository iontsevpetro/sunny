//
//  LocationData.swift
//  Sunny
//
//  Created by Peter Iontsev on 3/12/18.
//  Copyright © 2018 Peter Iontsev. All rights reserved.
//

import Foundation
import CoreLocation

func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
        guard let placemark = placemarks?.first, error == nil else {
            completion(nil, error)
            return
        }
        completion(placemark, nil)
    }
}
