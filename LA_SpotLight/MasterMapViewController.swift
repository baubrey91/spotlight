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
    let initialLocation = CLLocation(latitude: 34.0522, longitude: -118.2437)
    let regionRadius: CLLocationDistance = 20000
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        for location in filteredArray{
            if location.location != nil {
                let p = Pin(title: location.production!, coordinate: location.location!)
                pins.append(p)
            }
        }
        mapView.addAnnotations(pins)
        centerMapOnLocation(location: initialLocation)
    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}


