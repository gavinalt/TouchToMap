//
//  PlaceMapMarker.swift
//  TouchToMap
//
//  Created by Gavin Li on 4/30/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit
import MapKit

class PlaceMapMarker: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            if let placeAnnotation = newValue as? Place {
                glyphText = "🏫"
                clusteringIdentifier = "cluster"
                markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
                canShowCallout = true
                
                let popUpWindow = UIStackView()
                popUpWindow.distribution  = UIStackView.Distribution.equalSpacing
                popUpWindow.alignment = UIStackView.Alignment.center
                popUpWindow.spacing = 8.0

                let lbl: UILabel = {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.lineBreakMode = .byTruncatingTail
                    label.font = UIFont(name: "HelveticaNeue", size: 11)
                    label.textColor = .black
                    label.textAlignment = .left
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                } ()
                lbl.text = placeAnnotation.desc
                
                let imageView: UIImageView = {
                    let img = UIImageView()
                    img.contentMode = .scaleAspectFit
                    img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
                    img.layer.cornerRadius = 5
                    img.clipsToBounds = true
                    return img
                } ()
                imageView.image = UIImage(named: placeAnnotation.imageName)
                imageView.heightAnchor.constraint(equalToConstant: 128.0).isActive = true

                popUpWindow.translatesAutoresizingMaskIntoConstraints = false
                popUpWindow.axis = .vertical
                popUpWindow.addArrangedSubview(lbl)
                popUpWindow.addArrangedSubview(imageView)
                
                detailCalloutAccessoryView = popUpWindow
            }
        }
    }
}
