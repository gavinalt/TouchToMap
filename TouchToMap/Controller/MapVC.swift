//
//  MapVC.swift
//  TouchToMap
//
//  Created by Gavin Li on 4/30/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    var dataService: DataService = DataService()
    var places: [Place] = []
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        places = dataService.loadPlaces()
        
        if let onePlace = places.first {
            setMapCenterRegion(to: onePlace.location, with: 1000.0, for: mapView)
        }
        addAnnotation(for: places, on: mapView)
    }
    
    func setMapCenterRegion(to location: CLLocation, with radius: CLLocationDistance, for mapView: MKMapView) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
    
    func addAnnotation(for locations: [Place], on mapView: MKMapView) {
        mapView.addAnnotations(locations)
        mapView.register(PlaceMapMarker.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
}

extension MapVC: MKMapViewDelegate {
    
}
