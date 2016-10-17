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
    
    override func viewDidLoad() {
        filteredArray = locationsArray.filter {
            $0.category.contains(categoryString)
        }
        print(filteredArray.count)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        dateArray = locationsArray
        categoryArray.sort(by: {$0 < $1 })
        dateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        //filteredArray = locationsArray
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
}

extension FilteredTableViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage(named: "mapIcon")
        cell.textLabel!.text = filteredArray[indexPath.row].production
        cell.imageView?.isHidden = (filteredArray[indexPath.row].location?.latitude != nil) ?
                false :
            true
            /*cell.imageView?.isHidden = (filteredArray[indexPath.row].location?.latitude != nil) ?
             true :
             false*/
        return cell
    }
}

extension FilteredTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        vc.film = filteredArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

extension FilteredTableViewController :  UISearchBarDelegate {
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
}
