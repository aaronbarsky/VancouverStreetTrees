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
}
