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
        configureButton()
        centerMapOnLocation(location: initialLocation)
    }
    
    fileprivate func configureButton() {
        closeButton.layer.shadowColor = UIColor.black.cgColor
        closeButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        closeButton.layer.masksToBounds = false
        closeButton.layer.shadowRadius = 1.0
        closeButton.layer.shadowOpacity = 0.5
        closeButton.layer.cornerRadius = closeButton.frame.width / 2
    }
    
    fileprivate func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

