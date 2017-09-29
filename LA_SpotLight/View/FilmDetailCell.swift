//
//  DemoCell.swift
//  LA_SpotLight
//
//  Created by Brandon on 9/18/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import UIKit
import MapKit

class FilmDetailCell: FoldingCell {
    
    @IBOutlet weak var filmLabel: UILabel!
    @IBOutlet weak var detailFilmLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var permitLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var film: FilmLocation? {
        didSet {
            self.filmLabel.text = film?.production
            self.detailFilmLabel.text = film?.production
            self.addressLabel.text = film?.locationAddress
            self.permitLabel.text = film?.permitNumber
            self.dateLabel.text = String(describing: (film?.date!)!).stripTime()
            self.companyLabel.text = film?.productionCompany
            self.categoryLabel.text = film?.category
            
            guard let loc = film?.location else {
                mapView.isHidden = true
                return
                
//                let alert = UIAlertController(title: "Alert", message: "Sorry no gps coordinates on file", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                return
            }
            mapView.isHidden = false
            let pin = Pin(title: (film?.production)!, coordinate: loc)
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate,regionRadius * 2.0, regionRadius * 2.0)
            
            mapView.addAnnotation(pin)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2]
        return durations[itemIndex]
    }
    
}

