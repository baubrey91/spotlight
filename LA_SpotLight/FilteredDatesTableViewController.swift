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
    
    let kCloseCellHeight: CGFloat = 76
    let kOpenCellHeight: CGFloat = 388
    
    //needs to be changed to size of filtered array
    let kRowsCount = 1000
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dateArray = locationsArray
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FilmDetailCell
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 1.0
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 1.2
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDateArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
         cell.imageView?.image = UIImage(named: "mapIcon")
         cell.textLabel!.text = filteredArray[indexPath.row].production
         cell.imageView?.isHidden = (filteredArray[indexPath.row].location?.latitude != nil) ?
         false :
         true
         
         return cell
         }*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FilmDetailCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.film = filteredDateArray[indexPath.row]
        cell.filmLabel.text = String(describing: filteredDateArray[indexPath.row].date!).stripTime()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
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
