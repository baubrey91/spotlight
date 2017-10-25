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
        df.dateFormat = cDate.dateFormat

        /*guard let location = json["location_address"] as? String
        else {
        return nil
        }
         //return nothing if there is no address!
         */
        self.category = json[cFilmLocation.category] as! String? ?? cFilmLocation.unknown
        if let date = json[cFilmLocation.date] as? String{
            let formattedDate = date.stripTime()
            let dfFormattedDate = df.date(from: formattedDate)
            if let formDate = dfFormattedDate { self.date = formDate as NSDate? }
        }
        
        let coordinatesJSON = json[cFilmLocation.coordinates] as? [String:Any]
        if let cordinateArr = coordinatesJSON?[cFilmLocation.coordinates] as? [Double]{
            self.location = CLLocationCoordinate2D(latitude:(cordinateArr[1]), longitude: (cordinateArr[0])) //((cordinateArr[1]), (cordinateArr[0]))
        }
        
        self.locationAddress = json[cFilmLocation.locationAddress] as? String ?? cFilmLocation.unknown
        self.permitNumber = (json[cFilmLocation.permitNumber] as? String)
        self.production = (json[cFilmLocation.production] as? String)
        self.productionCompany = (json[cFilmLocation.productionCompany] as? String)
    }
    
    class func filmLocations(array: [payload]) -> [FilmLocation] {
        var filmLocations = [FilmLocation]()
        let categorySet = NSMutableSet()
        for jsonDic in array {
            let fl = FilmLocation(json: jsonDic)
            filmLocations.append(fl)
            categorySet.add(jsonDic[cFilmLocation.category]!)
        }
        categoryArray = Array(categorySet) as! [String]
        categoryArray.sort(by: { $0 < $1 })
        return filmLocations
    }
}
