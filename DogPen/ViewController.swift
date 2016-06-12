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
    var isWarning: Bool = false
    var accuracyLevel: Double!
    var count: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        let perimeter = dogPen.boundary
        print("POLYGON")
        print(perimeter)
        
        self.loadSelectedOptions()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
//BUILDING A PEN - add 4 pins for rectangle/trapezium - capture in array - TL, TR, BL, BR etc. create polygon from array. Allow points to be moved and polygon updated. function addPin:type {} use enum for pins pf type TL, TR, BL, BR
//        @IBAction func longPressDetected(sender: UILongPressGestureRecognizer) {
//            let posn = sender.locationInView(view)
//            let newCoord: CLLocationCoordine2D = mapView(touchPoint, toCoordinateFromView: self.mapView)
//            myLbl.text = "Double Tap = \(newCoord))"
//        }
//        
//ANNOTATION TO CREATE PEN
        
   //     var dogPenannotation = DogPenAnnotations()

        let location:CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 39.546700000000001, longitude: -75.767600000000002)
        
        let annotation =  MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "The Location"
        annotation.subtitle = "Subtitle text"
        mapView.addAnnotation(annotation)
        

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.addPins(_:)))
        
        longPress.minimumPressDuration = 1.0
        
        mapView.addGestureRecognizer(longPress)
        
    }
//GESTURE RECOGNISER FOR DOGPEN
    
    func addPins (gestureRecognizer:UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(self.mapView)
        let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        newAnotation.title = "New Location"
        newAnotation.subtitle = "New Subtitle"
        print(newAnotation.title)
        print(newAnotation.coordinate)
        mapView.addAnnotation(newAnotation)
    }
//-----------------
    
    
    override func viewDidAppear(animated: Bool)
    {
        let latDelta = dogPen.overlayTopLeftCoordinate.latitude - dogPen.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let region = MKCoordinateRegionMake(dogPen.midCoordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func loadSelectedOptions()
    {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        mapView.mapType = MKMapType.Hybrid
        addBoundary()
        
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
    print("WARNING?= \(isWarning)")
    
    view.addSubview(warningView)
    }
    
    func UpdateAccuracyStatus () {
        
        let frame = CGRect(x: 160 + view.frame.width/2, y: view.frame.height - 45, width: 20, height: 20)
        let accuracyView = UIView(frame: frame)
        accuracyView.backgroundColor = UIColor.greenColor()
        accuracyView.layer.cornerRadius = 10
        
                if accuracyLevel == 1 {
                accuracyView.backgroundColor = UIColor.greenColor()
            } else
                if accuracyLevel == 2 {
                accuracyView.backgroundColor = UIColor.orangeColor()
            } else
                if accuracyLevel == 3 {
                accuracyView.backgroundColor = UIColor.redColor()
            }
        view.addSubview(accuracyView)

    }
    
//MARK: Location Delegate Methods
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let latestLocation = locations.last
        let perimeter = dogPen.boundary
        let userLocation = latestLocation?.coordinate
        let horizAcc = latestLocation!.horizontalAccuracy
        let vertAcc = latestLocation!.verticalAccuracy

        print("INSIDE POLYGON = \(isPointInsidePolygon(perimeter, test: userLocation!))")
        print("H_ACC = \(horizAcc)")
        print("V_ACC = \(vertAcc)")

        updateWarningStatus()
        count = count + 1
        
        print("COUNT = \(count)")
        
        //self.locationManager.stopUpdatingLocation()
        if horizAcc < 5.01 && vertAcc < 5.01 {
            accuracyLevel = 1
        } else if horizAcc < 10.01 && vertAcc < 10.01 {
            accuracyLevel = 2
        } else {
            accuracyLevel = 3
        }
        UpdateAccuracyStatus()

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: /(error.localizedDescription)")
    }
    
//CONFIDENCE IN CURRENT POSITION MEASUREMENT
    
    func updateConfidenceInPosition()
    {
        
    }

    func addBoundary()
    {
        let polygon = MKPolygon(coordinates: &dogPen.boundary, count: dogPen.boundaryPointsCount)
        
                mapView.addOverlay(polygon)
        
    }
    
//POLYGON RENDER

    func mapView (mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer
    {
       
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.strokeColor = UIColor.magentaColor()
            polygonView.lineWidth = 2.0
            return polygonView
    }
    
//ADD PIN USING LONG TOUCH GESTURE RECOGNISER
    
 //   var pinNum:Int! = 0
    
    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
//
//        sender.enabled = true
//        
//        pinNum = pinNum + 1
//        if pinNum < 5
//        {
//            let touchPoint = sender.locationInView(self.mapView)
//            let newCoord:CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
//            
//            
//            let newAnotation = MKPointAnnotation()
//            newAnotation.coordinate = newCoord
//            newAnotation.title = "New Location"
//            newAnotation.subtitle = "New Subtitle"
//            print(newAnotation.title)
//            print(newAnotation.coordinate)
//            mapView.addAnnotation(newAnotation)
//        } else
//        {
//            sender.enabled = false
//        }
//        
//        if boundary.count == 4 {
//            addBoundary()
//        }
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
            
            j = i
            
            if contains != true
            {
                isWarning = true
            } else
            {
                isWarning = false
            }
        }
        
        return contains
    }
}
