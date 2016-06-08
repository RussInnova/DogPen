//
//  DogPenOverlay.swift
//  DogPen View
//
//  Created by Niv Yahel on 2014-10-30.
//  Copyright (c) 2014 Chris Wagner. All rights reserved.
//

import UIKit
import MapKit

class DogPenOverlay: NSObject, MKOverlay {
  
  var coordinate: CLLocationCoordinate2D
  var boundingMapRect: MKMapRect
  
  init (dogPen: DogPenModel) {
    
    boundingMapRect = dogPen.overlayBoundingMapRect
    coordinate = dogPen.midCoordinate
    
  }
}