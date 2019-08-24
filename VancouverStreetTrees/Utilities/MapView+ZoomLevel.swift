//
//  MapView+ZoomLevel.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 2019-08-24.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
	func zoomLevel() -> Int {
		//From https://stackoverflow.com/questions/4189621/setting-the-zoom-level-for-a-mkmapview
		return Int(log2(360 * (Double(frame.size.width/256) / region.span.longitudeDelta)) + 1)
	}
}
