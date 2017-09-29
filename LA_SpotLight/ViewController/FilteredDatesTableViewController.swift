//
//  FilteredDatesTbleViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/24/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilteredDatesTableViewController: TableViewBaseViewController {
    
    var dateArray =         [FilmLocation]()
    var filteredDateArray = [FilmLocation]()
    var year =              0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateArray = filmLocations
        var startString:    String
        var endString:      String
        switch year{
        case 2016 :
            startString =   "\(year)-01-01"
            endString =     "\(year+10)-01-01"
            
        default :
            startString =   "\(year)-01-01"
            endString =     "\(year+1)-01-01"
        }
        
        let startDate =     df.date(from: startString)
        let endDate =       df.date(from: endString)
        
        for film in dateArray {
            if let fd =  film.date {
                if (fd.isGreaterThanDate(dateToCompare: startDate!)) && (fd.isLessThanDate(dateToCompare: endDate!)){
                    filteredDateArray.append(film)
                }
            }
        }
        
        filteredDateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        
        var isGreater = false
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        return isLess
    }
}
