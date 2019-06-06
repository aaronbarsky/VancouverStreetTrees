//
//  TreeAnnotation.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/5/19.
//  Copyright © 2019 YellowCedarSoftware. All rights reserved.
//

import Foundation
import MapKit
class TreeAnnotation:MKPointAnnotation {
    let feature:Feature

    init (feature:Feature) {
        self.feature = feature
        super.init()
        self.coordinate =  CLLocationCoordinate2D(latitude: CLLocationDegrees(feature.geometry.coordinates[1]), longitude: CLLocationDegrees(feature.geometry.coordinates[0]))
        self.title = feature.properties.commonName
        self.subtitle = feature.properties.genusName + " " + feature.properties.speciesName + " " + feature.properties.cultivarName

    }

    func detailURL() -> URL? {
        //Some species end in "  x" to signify a hybrid.  The spaces are invalid
        //url characters and what's more, won't be found in wikipedia
        let species = feature.properties.speciesName.lowercased().split(separator: " ").first!
        let genus = feature.properties.genusName.capitalized.split(separator: " ").first!
        return URL(string: "https://en.wikipedia.org/wiki/\(genus)_\(species)")
    }

    func color() -> UIColor {
        return GenusColors.shared.colorFor(genus: feature.properties.genusName)
    }
}
