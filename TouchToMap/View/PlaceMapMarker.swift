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
    
    private var annotationDetails: UIStackView
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        annotationDetails = UIStackView()
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        glyphText = "🏫"
        clusteringIdentifier = "cluster"
        markerTintColor = UIColor(displayP3Red: 0.082, green: 0.518, blue: 0.263, alpha: 1.0)
        canShowCallout = true
        detailCalloutAccessoryView = annotationDetails
        
        setupDetailview(stackView: annotationDetails)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(basedOn annotation: Place) {
        for subView in annotationDetails.subviews {
            if let lbl = subView as? UILabel {
                lbl.text = annotation.desc
            }
            if let imageView = subView as? UIImageView {
                imageView.image = UIImage(named: annotation.imageName)
            }
        }
    }
    
    private func setupDetailview(stackView: UIStackView) {
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        createSubviews(of: stackView)
    }
    
    private func createSubviews(of stackView: UIStackView) {
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
        let imageView: UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFit
            img.translatesAutoresizingMaskIntoConstraints = false
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
            return img
        } ()
        imageView.heightAnchor.constraint(equalToConstant: 128.0).isActive = true
        stackView.addArrangedSubview(lbl)
        stackView.addArrangedSubview(imageView)
    }
}
