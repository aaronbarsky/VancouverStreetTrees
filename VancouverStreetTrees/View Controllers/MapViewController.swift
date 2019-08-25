//
//  ViewController.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/2/19.
//  Copyright © 2019 YellowCedarSoftware. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class MapViewController: UIViewController {

    let markerReuseID = UUID().uuidString
    @IBOutlet weak var mapView: MKMapView!

	@IBOutlet weak var refreshButton: UIImageView!
	@IBOutlet weak var zoomInMessage: UIView!
	var locationManager:CLLocationManager!
	var animateLocationChange = false
    let treeRepository = TreeRepository()
	var moc:NSManagedObjectContext!
	var hiddenAnnotations:[MKAnnotation]?
	var infoPanelViewController:InfoPanelViewController!
	@IBOutlet weak var infoPanelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var infoPanelBottomConstraint: NSLayoutConstraint!
	
	let minimumZoomLevelForAnnotations = 16
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:markerReuseID)
        mapView.delegate = self
        mapView.showsUserLocation = true
		mapView.showsCompass = false
		zoomInMessage.layer.cornerRadius = 16
		refreshButton.layer.shadowRadius = 2
		refreshButton.layer.shadowOffset = CGSize(width: 2, height: 2)
		refreshButton.layer.shadowColor = UIColor.gray.cgColor
		refreshButton.layer.shadowOpacity = 1.0
		
		hideInfoPanel(animated: false)
        startLocationManager()
    }
	
	func hideInfoPanel(animated:Bool) {
		infoPanelBottomConstraint.constant = -infoPanelHeightConstraint.constant
		let duration = animated ? 0.25 : 0.0
			UIView.animate(withDuration: duration){
				self.view.layoutIfNeeded()
		}
	}
	
	func showInfoPanel(animated:Bool) {
		guard infoPanelBottomConstraint.constant < 0 else {
			return
		}
		infoPanelBottomConstraint.constant = 0
		let duration = animated ? 0.25 : 0.0
		UIView.animate(withDuration: duration){
			self.view.layoutIfNeeded()
		}
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
			refreshButton.isHidden = true
        }
    }
	
    func setViewToCityCenter() {
        let vancouverCenter = CLLocationCoordinate2D(latitude: 49.255, longitude: -123.14)
        let region = MKCoordinateRegion(center: vancouverCenter, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: animateLocationChange)
    }
	@IBAction func refreshTapped(_ sender: Any) {
		if CLLocationManager.locationServicesEnabled() {
			animateLocationChange = true
			locationManager.startUpdatingLocation()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		infoPanelViewController = segue.destination as? InfoPanelViewController
		infoPanelViewController.swipedToDismiss = {[unowned self] in
			self.hideInfoPanel(animated: true)
		}
	}
	
	
}

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            setViewToCityCenter()
        }
    }
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 0.2, longitudinalMeters: 0.2)
			mapView.setRegion(region, animated: animateLocationChange)
			locationManager.stopUpdatingLocation()
		}
	}
}

extension MapViewController:MKMapViewDelegate {
	
	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		hideOrRestoreAnnotations(mapView)
		if mapView.zoomLevel() > minimumZoomLevelForAnnotations {
			let mapRectBoundingBox = MapRectBoundingBox(rect: mapView.visibleMapRect)
			mapView.addAnnotations(treeRepository.unloadedAnnotationsFor(mapRectBoundingBox: mapRectBoundingBox))
		}
	}
	
	func hideOrRestoreAnnotations(_ mapView: MKMapView) {
		if mapView.zoomLevel() > minimumZoomLevelForAnnotations {
			if let hiddenAnnotations = hiddenAnnotations {
				mapView.addAnnotations(hiddenAnnotations)
				self.hiddenAnnotations = nil
				UIView.animate(withDuration: 0.25) {
					self.zoomInMessage.alpha = 0.0
				}
			}
		} else {
			if hiddenAnnotations == nil {
				hiddenAnnotations = mapView.annotations
				mapView.removeAnnotations(mapView.annotations)
				UIView.animate(withDuration: 0.25) {
					self.zoomInMessage.alpha = 1.0
				}
			}
		}
	}

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let treeAnnotation = annotation as? TreeAnnotation else {
            return nil
        }
		
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: markerReuseID)
        if let markerAnnotationView = view as? MKMarkerAnnotationView {
            markerAnnotationView.annotation = treeAnnotation
            markerAnnotationView.canShowCallout = false
            markerAnnotationView.glyphText = treeAnnotation.glyphText()
			markerAnnotationView.glyphImage = nil
            markerAnnotationView.markerTintColor = treeAnnotation.color()
            }
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation,
            let treeAnnotation = annotation as? TreeAnnotation {
			showInfoPanel(animated: true)
			infoPanelViewController.bindTo(treeAnnotation: treeAnnotation)
        }
    }


}
