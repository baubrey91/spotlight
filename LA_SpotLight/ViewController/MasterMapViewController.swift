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
    
    //-----------------------//
    //MARK:- View Life Cycle
    //-----------------------// 
    
    var film: FilmLocation!
    fileprivate var pins = [Pin]()
    fileprivate let initialLocation = CLLocation(latitude: 34.0522, longitude: -118.2437)
    fileprivate let regionRadius: CLLocationDistance = 20000
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
   
    //-----------------------//
    //MARK:- View Life Cycle
    //-----------------------//
    
    override func viewDidLoad() {
        if film.location != nil {
            let pin = Pin(title: film.production!, coordinate: film.location!)
            mapView.addAnnotation(pin)
        }
        
        centerMapOnLocation(location: initialLocation)
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView.delegate = nil
        mapView.removeFromSuperview()
        mapView = nil
    }
    
    //-----------------------//
    //MARK:- Functions
    //-----------------------//
    
    fileprivate func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

