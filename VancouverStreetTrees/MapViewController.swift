//
//  ViewController.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/2/19.
//  Copyright © 2019 PayByPhone. All rights reserved.
//

import UIKit
import MapKit
import GameKit

class TreeAnnotation:MKCircle {
    var feature:Feature!
    func setFeature(feature:Feature) {
        assert(self.feature == nil)
        self.feature = feature
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var locationManager:CLLocationManager!
    var quadTree:GKQuadtree<TreeAnnotation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        //        let treeDataJsonFileURL = Bundle.main.url(forResource: "StreetTrees_CityWide", withExtension: "json")!
        let treeDataJsonFileURL = Bundle.main.url(forResource: "smalltrees", withExtension: "json")!

        let treeData = try! Data(contentsOf: treeDataJsonFileURL)
        let allTrees = try! JSONDecoder().decode([Feature].self, from: treeData)


        //        let smallerTrees = try! JSONEncoder().encode(allTrees.features)
        //        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,  true).first!
        //        let outpuFile = NSURL(fileURLWithPath: "smalltrees.json", relativeTo: NSURL(fileURLWithPath: documentsDirectory, isDirectory: true) as URL)
        //        print ("\(outpuFile)")x
        //        try! smallerTrees.write(to: outpuFile as URL)

        let treeAnnotations:[TreeAnnotation] = allTrees.map { feature in

            let center =  CLLocationCoordinate2D(latitude: CLLocationDegrees(feature.geometry.coordinates[1]),
                                                 longitude: CLLocationDegrees(feature.geometry.coordinates[0]))
            let circle = TreeAnnotation(center: center, radius: CLLocationDistance(feature.properties.diameter * 0.05))
            circle.setFeature(feature: feature)
            return circle
        }

        let vanMin = vector_float2(49.195, -123.27 )
        let vanMax = vector_float2(49.315, -123.020 )

        let vancouverQuad = GKQuad(quadMin:vanMin, quadMax: vanMax)
        quadTree = GKQuadtree(boundingQuad: vancouverQuad, minimumCellSize: 0.001)
        treeAnnotations.forEach {
            let vector = vector_float2($0.feature.geometry.coordinates[1], $0.feature.geometry.coordinates[0])
            quadTree.add($0, at: vector)
        }


        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

}


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

extension MapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 0.2, longitudinalMeters: 0.2)
        mapView.setRegion(region, animated: false)

    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let bbox = BoundingBox(rect: mapView.visibleMapRect)



      //  mapView.removeAnnotations(mapView.annotations)

        print ("Map rect \(bbox)")
        let quadMin = vector_float2(Float(bbox.min.latitude), Float(bbox.min.longitude))
        let quadMax = vector_float2(Float(bbox.max.latitude), Float(bbox.max.longitude))
        let quad = GKQuad(quadMin: quadMin, quadMax: quadMax)
        print ("Quad \(quad)")

        let annotationsInBoundingBox = quadTree.elements(in: quad)
        mapView.addOverlays(annotationsInBoundingBox)
//        mapView.addAnnotations(annotationsInBoundingBox)

    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let treeOverlay = overlay as? TreeAnnotation else {
            fatalError("What the fuck")

        }
        let renderer = MKCircleRenderer(circle: treeOverlay)
        renderer.fillColor = treeOverlay.feature.properties.genusName.lowercased() == "acer" ?
            .red : .gray
        return renderer
    }
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let treeAnnotation = annotation as? TreeAnnotation else {
            return nil
        }
        let annoView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKMarkerAnnotationView ??
            MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annoView.annotation = treeAnnotation
//        annoView.clusteringIdentifier = treeAnnotation.feature.properties.commonName
        annoView.canShowCallout = true
        annoView.glyphText = String(treeAnnotation.feature.properties.genusName.first ?? " ") + String(treeAnnotation.feature.properties.speciesName.first ?? " ")

        annoView.glyphImage = nil
        annoView.markerTintColor = UIColor.init(white: 0, alpha: CGFloat(min(0.3, treeAnnotation.feature.properties.diameter / 30)))
        return annoView
    }
 \*/
}
