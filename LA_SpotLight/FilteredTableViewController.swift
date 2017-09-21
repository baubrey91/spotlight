//
//  FilteredTableViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/9/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilteredTableViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var filteredArray = [FilmLocation]()
    var categoryString = ""
    var dateArray = [FilmLocation]()
    var category = false
    var film = FilmLocation.self
    let kCloseCellHeight: CGFloat = 76
    let kOpenCellHeight: CGFloat = 388
    
    //needs to be changed to size of filtered array
    let kRowsCount = 1000
    var cellHeights: [CGFloat] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        self.title = categoryString
        filteredArray = locationsArray.filter {
            $0.category.contains(categoryString)
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        dateArray = locationsArray
        categoryArray.sort(by: {$0 < $1 })
        dateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.enablesReturnKeyAutomatically = false
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
}

extension FilteredTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.film = filteredArray[indexPath.row]
        cell.filmLabel.text = filteredArray[indexPath.row].production
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}
extension FilteredTableViewController:  UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray.removeAll()
        
        if searchText.characters.count > 0 {
            filteredArray = locationsArray.filter {
                ($0.production?.contains(searchText))!
            }
        }
        else {
            filteredArray.append(contentsOf: locationsArray)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
}
