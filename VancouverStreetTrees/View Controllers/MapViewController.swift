//
//  ViewController.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/2/19.
//  Copyright © 2019 YellowCedarSoftware. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let markerReuseID = UUID().uuidString
    @IBOutlet weak var mapView: MKMapView!

    var locationManager:CLLocationManager!
    let treeRepository = TreeRepository()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:markerReuseID)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        startLocationManager()
    }

    func startLocationManager() {

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            setViewToCityCenter()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    func setViewToCityCenter() {
        let vancouverCenter = CLLocationCoordinate2D(latitude: 49.255, longitude: -123.14)
        let region = MKCoordinateRegion(center: vancouverCenter, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: false)
    }
}

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            setViewToCityCenter()
        }
    }
}

extension MapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 0.2, longitudinalMeters: 0.2)
        mapView.setRegion(region, animated: false)

    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let mapRectBoundingBox = MapRectBoundingBox(rect: mapView.visibleMapRect)
        let newAnnotations = treeRepository.unloadedAnnotationsFor(boundingBox: mapRectBoundingBox.cgRect)
        mapView.addAnnotations(newAnnotations)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let treeAnnotation = annotation as? TreeAnnotation else {
            return nil
        }
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: markerReuseID)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.annotation = treeAnnotation
            markerAnnotationView.canShowCallout = false
            markerAnnotationView.glyphText = String(treeAnnotation.feature.properties.genusName.first ?? " ") + String(treeAnnotation.feature.properties.speciesName.first ?? " ")
            markerAnnotationView.glyphImage = nil
            markerAnnotationView.markerTintColor = treeAnnotation.color()
            }
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation,
            let treeAnnotation = annotation as? TreeAnnotation {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let wikipediaVC = storyboard.instantiateViewController(withIdentifier: "WikipediaVC") as! WikipediaViewController
            _ = wikipediaVC.view
            let url = treeAnnotation.detailURL()!
            let urlRequest = URLRequest(url: url)
            wikipediaVC.webView.load(urlRequest)
            navigationController?.pushViewController(wikipediaVC, animated: true)
        }
    }


}
