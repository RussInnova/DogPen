//
//  DogPennAnnotationView.swift
//  DogPen
//
//  Created by Keith Russell on 6/10/16.
//  Copyright © 2016 Keith Russell. All rights reserved.
//

import UIKit
import MapKit

class DogPenAnnotationView: MKAnnotationView {
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called when drawing the DogPenAnnotationView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        let dogPenAnnotation = self.annotation as! DogPenAnnotations
        switch (dogPenAnnotation.type) {
        case .TopLeft:
            image = UIImage(named: "topleft")
        case .TopRight:
            image = UIImage(named: "topright")
        case .BottomRight:
            image = UIImage(named: "bottomright")
        case .BottomLeft:
            image = UIImage(named: "bottomleft")
        }
    }
}