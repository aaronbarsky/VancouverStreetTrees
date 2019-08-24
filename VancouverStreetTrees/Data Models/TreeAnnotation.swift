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
	let tree:Tree
	init (tree:Tree) {
		self.tree = tree
		super.init()
		
		self.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(tree.latitude),
												 longitude: CLLocationDegrees(tree.longitude))
		self.title = tree.commonName
		self.subtitle = tree.genusName! +  " " + tree.speciesName!
		
	}

    func detailURL() -> URL {
        //Some species end in "  x" to signify a hybrid.  The spaces are invalid
        //url characters and what's more, won't be found in wikipedia
        let species = tree.speciesName!.lowercased().split(separator: " ").first!
        let genus = tree.genusName!.capitalized.split(separator: " ").first!
        return URL(string: "https://en.wikipedia.org/wiki/\(genus)_\(species)")!
    }
	
	func glyphText() -> String {
		return String(tree.genusName!.first!) + String(tree.speciesName!.first!)
	}

    func color() -> UIColor {
        return GenusColors.shared.colorFor(genus: tree.genusName!)
    }
}
