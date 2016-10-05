//
//  FilmLocationModel.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/27/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation

struct FilmLocation {
    
    var category: String
    var date: NSDate?
    var location: (latitude: Double, longitude: Double)?
    var locationAddress: String
    var permitNumber : String?
    var production : String?
    var productionCompany : String?

}
extension FilmLocation{
    init?(json: [String: Any]) {
        /*guard let location = json["location_address"] as? String
        else {
        return nil
        }
         //return nothing if there is no address!
         */
        self.category = json["category"] as! String? ?? "unknown"
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        if let date = json["date"] as? String{
            let formattedDate = date.stripTime()
            let dfFormattedDate = df.date(from: formattedDate)
            if let formDate = dfFormattedDate { self.date = formDate as NSDate? }
        }
        
        let coordinatesJSON = json["location"] as? [String:Any]
        if let cordinateArr = coordinatesJSON?["coordinates"] as? [Double]{
            self.location = ((cordinateArr[1]), (cordinateArr[0]))
        }
        
        self.locationAddress = json["location_address"] as! String? ?? "unknown"
        self.permitNumber = (json["permit_no"] as? String)
        self.production = (json["production"] as? String)
        self.productionCompany = (json["production_company"] as? String)
    }
}

extension String {
    func stripTime() -> String{
        return self[(self.startIndex)..<(self.index((self.startIndex), offsetBy: 10))]
    }
}
