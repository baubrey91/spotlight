//
//  FilteredDatesTbleViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/24/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilteredDatesTableViewController: UITableViewController {
    
    var dateArray =         [FilmLocation]()
    var filteredDateArray = [FilmLocation]()
    var year =              0
    var month =             1


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dateArray = locationsArray
        var startString:    String
        var endString:      String
        print(month)
        switch month{
        case 10,11 :
            startString =   "\(year)-\(month)-01"
            endString =     "\(year)-\(month+1)-01"
        case 12:
            startString =   "\(year)-\(month)-01"
            endString =     "\(year+1)-01-01"
        default :
            startString =   "\(year)-0\(month)-01"
            endString =     "\(year)-0\(month+1)-01"
        }

        let startDate =     df.date(from: startString)
        let endDate =       df.date(from: endString)
        
        print(startString)
        print(endString)
        for film in dateArray {
            if let fd =  film.date {
                if (fd.isGreaterThanDate(dateToCompare: startDate!)) && (fd.isLessThanDate(dateToCompare: endDate!)){
                    filteredDateArray.append(film)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel!.text = String(describing: filteredDateArray[indexPath.row].date!).stripTime()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDateArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        vc.film = filteredDateArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
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
