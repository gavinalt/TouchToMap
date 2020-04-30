//
//  Place.swift
//  TouchToMap
//
//  Created by Gavin Li on 4/30/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject {
    
    let name: String
    let location: CLLocation
    let desc: String
    let imageName: String
    
    init(name: String, latitude: Double, longitude: Double, description: String, imageName: String) {
        self.name = name
        location = CLLocation(latitude: latitude, longitude: longitude)
        self.desc = description
        self.imageName = imageName
    }
    
}

extension Place: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get { location.coordinate }
    }
    
    var title: String? {
        get { name }
    }
}
