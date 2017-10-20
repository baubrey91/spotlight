//
//  FilteredTableViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 10/9/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilteredTableViewController: TableViewBaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var categoryString = ""
    var dateArray = [FilmLocation]()
    var category = false
    var film = FilmLocation.self

    override func viewDidLoad() {
        
        self.title = categoryString
        setup()
        filteredArray = filmLocations.filter {
            $0.category.contains(categoryString)
        }
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        filmLocations.sort(by: {$0.production! < $1.production! })
        dateArray = filmLocations
        categoryArray.sort(by: {$0 < $1 })
        dateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.enablesReturnKeyAutomatically = false
        
        //cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
}

extension FilteredTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray.removeAll()
        
        if searchText.characters.count > 0 {
            filteredArray = filmLocations.filter {
                ($0.production?.contains(searchText))!
            }
        }
        else {
            filteredArray.append(contentsOf: filmLocations)
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    }
}
