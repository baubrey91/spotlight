//
//  FilmLocationModel.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/27/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import UIKit
import MapKit

class FilmLocation {
    
    var category: String
    var date: NSDate?
    var location: CLLocationCoordinate2D?
    var locationAddress: String
    var permitNumber : String?
    var production : String?
    var productionCompany : String?
    
    init (json: payload) {
        df.dateFormat = "yyyy-MM-dd"

        /*guard let location = json["location_address"] as? String
        else {
        return nil
        }
         //return nothing if there is no address!
         */
        self.category = json["category"] as! String? ?? "unknown"
        if let date = json["date"] as? String{
            let formattedDate = date.stripTime()
            let dfFormattedDate = df.date(from: formattedDate)
            if let formDate = dfFormattedDate { self.date = formDate as NSDate? }
        }
        
        let coordinatesJSON = json["location"] as? [String:Any]
        if let cordinateArr = coordinatesJSON?["coordinates"] as? [Double]{
            self.location = CLLocationCoordinate2D(latitude:(cordinateArr[1]), longitude: (cordinateArr[0])) //((cordinateArr[1]), (cordinateArr[0]))
        }
        
        self.locationAddress = json["location_address"] as! String? ?? "unknown"
        self.permitNumber = (json["permit_no"] as? String)
        self.production = (json["production"] as? String)
        self.productionCompany = (json["production_company"] as? String)
    }
    
    class func filmLocations(array: [payload]) -> [FilmLocation] {
        var filmLocations = [FilmLocation]()
        let categorySet = NSMutableSet()
        for jsonDic in array {
            let fl = FilmLocation(json: jsonDic)
            filmLocations.append(fl)
            categorySet.add(jsonDic["category"]!)
        }
        categoryArray = Array(categorySet) as! [String]
        categoryArray.sort(by: { $0 < $1 })
        return filmLocations
    }
}

extension String {
    func stripTime() -> String{
        return self[(self.startIndex)..<(self.index((self.startIndex), offsetBy: 10))]
    }
}
