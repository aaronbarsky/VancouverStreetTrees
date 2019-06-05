import Foundation
import MapKit
import CoreLocation
//From https://stackoverflow.com/questions/2081753/getting-the-bounds-of-an-mkmapview/43200968#43200968
struct BoundingBox {
    let min: CLLocationCoordinate2D
    let max: CLLocationCoordinate2D

    init(rect: MKMapRect) {
        let bottomLeft = MKMapPoint(x: rect.origin.x, y: rect.maxY)
        let topRight = MKMapPoint(x: rect.maxX, y: rect.origin.y)

        min = bottomLeft.coordinate
        max = topRight.coordinate
    }
}
