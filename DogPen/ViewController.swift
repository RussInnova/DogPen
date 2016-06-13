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
    
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 100
    var boundary: [CLLocationCoordinate2D] = []
    var isWarning: Bool = false
    var accuracyLevel: Double!
    var count: Int = 0
    var polygon: [CLLocationCoordinate2D]?
    var latestLocation: CLLocation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        self.loadSelectedOptions()
        let location = locationManager.location
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, regionRadius * 1.5, regionRadius * 1.5)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func loadSelectedOptions()
    {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        mapView.mapType = MKMapType.Hybrid
    }
    
//INSIDE OR OUTSIDE OF BOUNDARY

    func updateWarningStatus ()
    {
        let frame = CGRect(x: -30 + view.frame.width/2, y: view.frame.height - 45, width: 20, height: 20)
        let warningView = UIView(frame: frame)
        warningView.backgroundColor = UIColor.greenColor()
        warningView.layer.cornerRadius = 10
        
            if isWarning
        {
            warningView.backgroundColor = UIColor.redColor()
        } else
        {
            warningView.backgroundColor = UIColor.greenColor()
        }
    
    view.addSubview(warningView)
        
    }
    
    func UpdateAccuracyStatus ()
    {
        let frame = CGRect(x: 160 + view.frame.width/2, y: view.frame.height - 45, width: 20, height: 20)
        let accuracyView = UIView(frame: frame)
        accuracyView.backgroundColor = UIColor.greenColor()
        accuracyView.layer.cornerRadius = 10
        
                if accuracyLevel == 1
                {
                    accuracyView.backgroundColor = UIColor.greenColor()
                } else
                if accuracyLevel == 2
                {
                accuracyView.backgroundColor = UIColor.orangeColor()
                } else
                if accuracyLevel == 3
                {
                accuracyView.backgroundColor = UIColor.redColor()
                }
        
    view.addSubview(accuracyView)

    }
    
//MARK: Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let latestLocation = locations.last
        
        if isPointInsidePolygon(boundary, test: (latestLocation?.coordinate)!) {
            isWarning = false
        } else {
            isWarning = true
        }
        
        let horizAcc = latestLocation!.horizontalAccuracy
        let vertAcc = latestLocation!.verticalAccuracy
        
        updateWarningStatus()
       
        if horizAcc < 5.01 && vertAcc < 5.01
        {
            accuracyLevel = 1
        } else if horizAcc < 10.01 && vertAcc < 10.01
        {
            accuracyLevel = 2
        } else
        {
            accuracyLevel = 3
        }
        UpdateAccuracyStatus()

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: /(error.localizedDescription)")
    }

//MAPVIEW RENDERER RENDER

    func mapView (mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
        let polygonView = MKPolygonRenderer(overlay: overlay)
        polygonView.strokeColor = UIColor.magentaColor()
        polygonView.lineWidth = 2.0
        return polygonView
    }
    
//ADD PIN USING LONG TOUCH GESTURE RECOGNISER
    
    var pinNum = 0
    
    @IBAction func addPin(sender: UILongPressGestureRecognizer)
    {
        if (sender.state == UIGestureRecognizerState.Began) //Use this state because it only fires once
        {
            pinNum = pinNum + 1

            if pinNum < 5
            
        {
            let touchPoint = sender.locationInView(self.mapView)
            let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            
            let newAnotation = MKPointAnnotation()
            newAnotation.coordinate = newCoord
            newAnotation.title = "Pin # \(pinNum)"
            newAnotation.subtitle = ""
            
            boundary.append(newCoord)
            mapView.addAnnotation(newAnotation)
           
        }
            
        if boundary.count == 4
        {
            let polygon = MKPolygon(coordinates: &boundary, count: boundary.count)
            
            mapView.addOverlay(polygon)
        }
        }
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        pinNum = 0
        boundary = []
    }
    
//SWIFT RENDITION OF PNPOLY ALGORITHM TO FIND OUT IF POINT IS INSIDE A POLYGON
    
    func isPointInsidePolygon(polygon: [CLLocationCoordinate2D], test:CLLocationCoordinate2D) -> Bool
    {
        
        var j:Int = polygon.count - 1
        var  contains = false
        
        for i in 0..<polygon.count
        {
            if (((polygon[i].latitude < test.latitude && polygon[j].latitude >= test.latitude) || (polygon[j].latitude < test.latitude && polygon[i].latitude >= test.latitude))
                && (polygon[i].longitude <= test.longitude || polygon[j].longitude <= test.longitude))
            {
                contains = (polygon[i].longitude + (test.latitude - polygon[i].latitude) / (polygon[j].latitude - polygon[i].latitude) * (polygon[j].longitude - polygon[i].longitude) < test.longitude)
            }
            
            j = i        }
        
        return contains
    }
}
