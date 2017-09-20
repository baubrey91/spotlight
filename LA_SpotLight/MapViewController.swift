//
//  MapViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/28/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    var film = FilmLocation(json: [String:Any]())
    
    @IBOutlet weak var map:                     MKMapView!
    
    @IBOutlet weak var productionLabel:         UILabel!
    @IBOutlet weak var productionCompanyLabel:  UILabel!
    @IBOutlet weak var categoryLabel:           UILabel!
    @IBOutlet weak var dateLabel:               UILabel!
    @IBOutlet weak var permitLabel:             UILabel!
    @IBOutlet weak var addressLabel:            UILabel!

    override func viewDidLoad() {
        productionLabel.text = film?.production
        productionCompanyLabel.text = film?.productionCompany
        categoryLabel.text = film?.category
        dateLabel.text = String(describing: (film?.date!)!).stripTime()
        permitLabel.text = film?.permitNumber
        addressLabel.text = film?.locationAddress
       
        guard let loc = film?.location else {
            
            let alert = UIAlertController(title: "Alert", message: "Sorry no gps coordinates on file", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let pin = Pin(title: (film?.production)!, coordinate: loc)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate,regionRadius * 2.0, regionRadius * 2.0)

        map.addAnnotation(pin)
        map.setRegion(coordinateRegion, animated: true)

    }
}
