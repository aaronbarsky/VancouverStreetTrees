//
//  ViewController.swift
//  VancouverStreetTrees
//
//  Created by Aaron Barsky on 6/2/19.
//  Copyright © 2019 YellowCedarSoftware. All rights reserved.
//

import UIKit
import MapKit
import GameKit

class MapViewController: UIViewController {

    let markerReuseID = UUID().uuidString
    @IBOutlet weak var mapView: MKMapView!

    var locationManager:CLLocationManager!
    var quadTree:GKQuadtree<TreeAnnotation>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let allTrees = loadTreeData()
        let treeAnnotations = allTrees.map {
            TreeAnnotation(feature: $0)
        }

        let vanMin = vector_float2(49.195, -123.27 )
        let vanMax = vector_float2(49.315, -123.020 )

        let vancouverQuad = GKQuad(quadMin:vanMin, quadMax: vanMax)
        quadTree = GKQuadtree(boundingQuad: vancouverQuad, minimumCellSize: 0.001)
        treeAnnotations.forEach {
            let vector = vector_float2($0.feature.geometry.coordinates[1], $0.feature.geometry.coordinates[0])
            quadTree.add($0, at: vector)
        }

        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier:markerReuseID)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    func loadTreeData() -> [Feature] {
        let treeDataJsonFileURL = Bundle.main.url(forResource: "smalltrees", withExtension: "json")!
        let treeData = try! Data(contentsOf: treeDataJsonFileURL)
        return try! JSONDecoder().decode([Feature].self, from: treeData)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            setViewToEntireCity()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    func setViewToEntireCity() {
        let vancouverCenter = CLLocationCoordinate2D(latitude: 49.255, longitude: -123.14)
        let region = MKCoordinateRegion(center: vancouverCenter, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: false)
    }

    let genusToColor:[String:Int] = [
        "ABIES": 0xe57e39,
        "ACER": 0x6d731d,
        "AESCULUS": 0x66cc81,
        "AILANTHUS": 0x002233,
        "ALBIZIA": 0x2200ff,
        "ALNUS": 0x40003c,
        "AMELANCHIER": 0xe50000,
        "ARALIA": 0x331c0d,
        "ARAUCARIA": 0x585943,
        "ARBUTUS": 0x3df285,
        "BETULA": 0x40bfff,
        "CALOCEDRUS": 0x1a00bf,
        "CARPINUS": 0xe600b8,
        "CASTANEA": 0xd90000,
        "CATALPA": 0x806c60,
        "CEDRUS": 0xdae6ac,
        "CELTIS": 0x26332b,
        "CERCIDIPHYLLUM": 0x0081f2,
        "CERCIS": 0x0e0066,
        "CHAMAECYPARIS": 0xb32d86,
        "CHITALPA": 0x990000,
        "CLADRASTIS": 0x7f4400,
        "CLERODENDRON": 0xa1f200,
        "CORNUS": 0x0d3321,
        "CORYLUS": 0x2d74b3,
        "CRATAEGUS": 0x9180ff,
        "CRYPTOMERIA": 0xd90074,
        "CUPRESSOCYPARIS   X": 0x660000,
        "DAVIDIA": 0xf29d3d,
        "EUCALYPTUS": 0x86b32d,
        "EUCOMMIA": 0x4d665a,
        "EUONYMUS": 0xaccbe6,
        "FAGUS": 0x6930bf,
        "FICUS": 0x661a42,
        "FRAXINUS": 0xe6acac,
        "GENUS_NAME": 0x4c3213,
        "GINKGO": 0x26330d,
        "GLEDITSIA": 0xa3d9c7,
        "HALESIA": 0x697c8c,
        "HIBISCUS": 0x1b0033,
        "HIPPOPHAE": 0xff0066,
        "ILEX": 0x330700,
        "JUGLANS": 0xb28959,
        "JUNIPERUS": 0xd4ff80,
        "KALOPANAX": 0x00ffcc,
        "KOELREUTERIA": 0x0061f2,
        "LABURNUM": 0x421a66,
        "LARIX": 0x7f0033,
        "LAURUS": 0xcc7466,
        "LIQUIDAMBAR": 0xd9bfa3,
        "LIRIODENDRON": 0x6c8060,
        "LTF SPECIMEN": 0x20806c,
        "MAGNOLIA": 0x79aaf2,
        "MALUS": 0x7f53a6,
        "MANGLIETIA": 0x330014,
        "MESPILUS": 0x402420,
        "METASEQUOIA": 0x403830,
        "MICHELIA": 0x598c46,
        "MORUS": 0x33ccc2,
        "NOTHOFAGUS": 0x405980,
        "NYSSA": 0xd940ff,
        "OSTRYIA": 0xf279aa,
        "OXYDENDRUM": 0xa6827c,
        "PARROTIA": 0x996600,
        "PAULOWNIA": 0x19bf00,
        "PHELLODENDON": 0x003033,
        "PICEA": 0x434c59,
        "PINUS": 0xcf73e6,
        "PLATANUS": 0xbf8fa3,
        "POPULUS": 0xf26d3d,
        "PRUNUS": 0xd9ad00,
        "PSEUDOTSUGA": 0x138c00,
        "PTELEA": 0x1a6166,
        "PTEROCARYA": 0x1d3473,
        "PTEROSTYRAX": 0x770080,
        "PYRUS": 0x4c0014,
        "QUERCUS": 0xa64b29,
        "RHAMNUS": 0x665200,
        "RHUS": 0xc8ffbf,
        "ROBINIA": 0xbffbff,
        "SALIX": 0x101d40,
        "SCIADOPITYS": 0xaa2db3,
        "SEQUOIA": 0xa65369,
        "SEQUOIADENDRON": 0xffa280,
        "SOPHORA": 0xffe680,
        "SORBUS": 0x005900,
        "STEWARTIA": 0x7ca3a6,
        "STYRAX": 0x263699,
        "SYRINGA": 0x562d59,
        "TAXODIUM": 0x663341,
        "TAXUS": 0x734939,
        "THUJA": 0x8c8569,
        "TILIA": 0x2d592d,
        "TRACHYCARPUS": 0x004759,
        "TSUGA": 0x5965b3,
        "ULMUS": 0x311a33,
        "VIBURNUM": 0x33262a,
        "ZELKOVA": 0xffd0bf
    ]
}

extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            setViewToEntireCity()
        }
    }
}


extension MapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 0.2, longitudinalMeters: 0.2)
        mapView.setRegion(region, animated: false)

    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let bbox = BoundingBox(rect: mapView.visibleMapRect)
        print ("Map rect \(bbox)")
        let quadMin = vector_float2(Float(bbox.min.latitude), Float(bbox.min.longitude))
        let quadMax = vector_float2(Float(bbox.max.latitude), Float(bbox.max.longitude))
        let quad = GKQuad(quadMin: quadMin, quadMax: quadMax)
        print ("Quad \(quad)")
        let annotationsInBoundingBox = quadTree.elements(in: quad)
        mapView.addAnnotations(annotationsInBoundingBox)
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
            let color = UIColor(rgb:genusToColor[treeAnnotation.feature.properties.genusName] ?? 0)
            markerAnnotationView.markerTintColor = color
            }
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation,
            let treeAnnotation = annotation as? TreeAnnotation {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let wikipediaVC = storyboard.instantiateViewController(withIdentifier: "WikipediaVC") as! WikipediaViewController
            _ = wikipediaVC.view
            let url = detailURLFor(feature: treeAnnotation.feature)!
            let urlRequest = URLRequest(url: url)
            wikipediaVC.webView.load(urlRequest)
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(wikipediaVC, animated: true)
        }
    }

    func detailURLFor(feature:Feature) -> URL? {
        //Some species end in "  x" to signify a hybrid.  The spaces are invalid
        //url characters and what's more, won't be found in wikipedia
        let species = feature.properties.speciesName.lowercased().split(separator: " ").first!
        let genus = feature.properties.genusName.capitalized.split(separator: " ").first!
        return URL(string: "https://en.wikipedia.org/wiki/\(genus)_\(species)")

    }
}
