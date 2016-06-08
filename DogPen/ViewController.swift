//
//  ViewController.swift
//  DogPen
//
//  Created by Keith Russell on 6/7/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var dogPen = DogPenModel(filename: "DogPen")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        self.loadSelectedOptions()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        
        
        }
    override func viewDidAppear(animated: Bool) {
        let latDelta = dogPen.overlayTopLeftCoordinate.latitude - dogPen.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake(dogPen.midCoordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func loadSelectedOptions() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        mapView.mapType = MKMapType.Hybrid
        addBoundary()
    }
    
//MARK: Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: /(error.localizedDescription)")
    }

    func addBoundary() {
        let polygon = MKPolygon(coordinates: &dogPen.boundary, count: dogPen.boundaryPointsCount)
        print (dogPen.boundary)
        mapView.addOverlay(polygon)
        
    }

    func addOverlay() {
    
    let overlay = DogPenOverlay(dogPen: dogPen)
    mapView.addOverlay(overlay)
    }

    func mapView (mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
       
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magentaColor()
            polygonView.lineWidth = 2.0
            return polygonView
    }
}
