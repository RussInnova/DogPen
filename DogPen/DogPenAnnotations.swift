//
//  DogPenAnnotations.swift
//  DogPen
//
//  Created by Keith Russell on 6/10/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import UIKit
import MapKit

enum PenCornerType: Int {
    case TopRight = 0
    case TopLeft = 1
    case BottomRight = 3
    case BottomLeft = 4
}

class DogPenAnnotations: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D  = CLLocationCoordinate2D (latitude: 39.546700000000001, longitude: -75.767600000000002)
    var title: String? = ""
    var subtitle: String? = ""
    var type: PenCornerType = PenCornerType.TopRight

    
//    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: PenCornerType) {
//        self.coordinate = coordinate
//        self.title = title
//        self.subtitle = subtitle
//        self.type = type
//    }
}