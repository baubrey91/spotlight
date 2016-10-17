//
//  MasterMapViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/6/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import MapKit
import UIKit



class MasterMapViewController: UIViewController {
    var filteredArray = [FilmLocation]()
    var pins = [Pin]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        for location in filteredArray{
            if location.location != nil {
                let p = Pin(title: location.production!, coordinate: location.location!)
                pins.append(p)
            }
        }
        mapView.addAnnotations(pins)
        
    }
}


