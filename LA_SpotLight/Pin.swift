//
//  Pin.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/6/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import MapKit

class Pin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
