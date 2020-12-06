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
	private var mapChangedFromUserInteraction = false
	let minimumZoomLevelForAnnotations = 16
	
	private var userCenteredRegion: MKCoordinateRegion?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:markerReuseID)
		mapView.delegate = self
		mapView.showsUserLocation = true
		mapView.showsCompass = false
		zoomInMessage.layer.cornerRadius = 16
		refreshButton.layer.shadowRadius = 2
		refreshButton.layer.shadowOffset = CGSize(width: 2, height: 2)
		refreshButton.layer.shadowColor = UIColor(named:"DropShadow")?.cgColor
		refreshButton.layer.shadowOpacity = 1.0
		
		hideInfoPanel(animated: false)
		startLocationManager()
		
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
		let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinchMap(_:)))
		panGesture.delegate = self
		pinchGesture.delegate = self
		mapView.addGestureRecognizer(panGesture)
		mapView.addGestureRecognizer(pinchGesture)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		refreshButton.layer.shadowColor = UIColor(named:"DropShadow")?.cgColor
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
			setViewForNoLocationServices()
		}
	}
	
	func setViewForNoLocationServices() {
		let vancouverCenter = CLLocationCoordinate2D(latitude: 49.255, longitude: -123.14)
		let region = MKCoordinateRegion(center: vancouverCenter, latitudinalMeters: 2500, longitudinalMeters: 2500)
		mapView.setRegion(region, animated: animateLocationChange)
		refreshButton.isHidden = true
	}
	
	@IBAction func refreshTapped(_ sender: Any) {
		if CLLocationManager.locationServicesEnabled() {
			animateLocationChange = true
			mapChangedFromUserInteraction = false
			if let userCenteredRegion = userCenteredRegion {
				mapView.setRegion(userCenteredRegion, animated: animateLocationChange)
			}
		}
	}
	
	@IBAction func zoomInTapped(_ sender: Any) {
		let region = MKCoordinateRegion(center:
											mapView.centerCoordinate, latitudinalMeters: 150.0, longitudinalMeters: 150.0)
		mapView.setRegion(region, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.destination is InfoPanelViewController {
			infoPanelViewController = segue.destination as? InfoPanelViewController
			infoPanelViewController.swipedToDismiss = {[unowned self] in
				self.hideInfoPanel(animated: true)
			}
		}
	}
	
}

extension MapViewController:CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .denied {
			setViewForNoLocationServices()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			userCenteredRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50.0, longitudinalMeters: 50.0)
			if !mapChangedFromUserInteraction,
			   let userCenteredRegion = userCenteredRegion {
				mapView.setRegion(userCenteredRegion, animated: animateLocationChange)
			}
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

//MARK Gesture recognizers for user map interadction
extension MapViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc func didDragMap(_ sender: UIGestureRecognizer) {
		if sender.state == .began {
			mapChangedFromUserInteraction = true
		}
	}
	
	@objc func didPinchMap(_ sender: UIGestureRecognizer) {
		if sender.state == .began {
			mapChangedFromUserInteraction = true
		}
	}
}
