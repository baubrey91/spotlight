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
    
    //--------------------------//
    //MARK:- Variables
    //--------------------------//
    
    var year: Int?
    
    //--------------------------//
    //MARK:- View Life Cycle
    //--------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        if let year = year {
            setUpDateArray(year: year)
        }
        
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
    }
    
    //--------------------------//
    //MARK:- Functions
    //--------------------------//
    
    private func setUpDateArray(year: Int) {
        var startString:    String
        var endString:      String
        switch year {
        case 2016 :
            startString =   "\(year)" + cDate.janFirst
            endString =     "\(year+10)" + cDate.janFirst
            
        default :
            startString =   "\(year)" + cDate.janFirst
            endString =     "\(year+1)" + cDate.janFirst
        }
        
        let startDate =     df.date(from: startString)
        let endDate =       df.date(from: endString)
        
        for film in filmLocations {
            if let fd =  film.date {
                if (fd.isGreaterThanDate(dateToCompare: startDate!)) && (fd.isLessThanDate(dateToCompare: endDate!)){
                    filteredArray.append(film)
                }
            }
        }
        filteredArray.sort(by: {$0.date?.compare($1.date! as Date) == ComparisonResult.orderedAscending })
    }
}

