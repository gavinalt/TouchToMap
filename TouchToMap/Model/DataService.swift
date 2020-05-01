//
//  DataService.swift
//  TouchToMap
//
//  Created by Gavin Li on 4/30/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

class DataService {
    
    func loadPlaces() -> [Place] {
        guard let entries = loadPlist() else { fatalError("Unable to load data") }
        
        var places: [Place] = []
        for property in entries {
            guard let name = property["Name"] as? String,
                let latitude = property["Latitude"] as? Double,
                let longitude = property["Longitude"] as? Double,
                let description = property["Description"] as? String,
                let imageName = property["ImageName"] as? String else { fatalError("Error reading data") }
            let place = Place.init(name: name, latitude: latitude, longitude: longitude, description: description, imageName: imageName)
            places.append(place)
        }
        
        return places
    }
    
    private func loadPlist() -> [[String: Any]]? {
        guard
            let plistUrl = Bundle.main.url(forResource: "Places", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistUrl) else { return nil }
        var placedEntries: [[String: Any]]? = nil
        
        do {
            placedEntries = try PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [[String: Any]]
        } catch {
            print("error reading plist")
        }
        return placedEntries
    }
}
