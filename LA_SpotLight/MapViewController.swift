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
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var productionCompanyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var permitLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func viewDidLoad() {
        productionLabel.text = film?.production
        productionCompanyLabel.text = film?.productionCompany
        categoryLabel.text = film?.category
        dateLabel.text = String(describing: film?.date!)
        permitLabel.text = film?.permitNumber
        addressLabel.text = film?.locationAddress
       
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                      regionRadius * 2.0, regionRadius * 2.0)
            map.setRegion(coordinateRegion, animated: true)
        }
        if let loco = film?.location {
            let location = CLLocation(latitude: (loco.latitude), longitude: (loco.longitude))
            centerMapOnLocation(location: location)
        }
        


    }
}
