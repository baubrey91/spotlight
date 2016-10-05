//
//  FilmTableViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/29/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilmTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var filteredArray = [FilmLocation]()
    var dateArray = [FilmLocation]()
    var category = false
    var film = FilmLocation.self
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        dateArray = locationsArray
        categoryArray.sort(by: {$0 < $1 })
        dateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        filteredArray = locationsArray
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
        vc.film = filteredArray[indexPath.row]
            
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
        cell.layer.backgroundColor = UIColor.white.cgColor

        switch segmentController.selectedSegmentIndex {
        case 0:
            cell.textLabel!.text = filteredArray[indexPath.row].production
            if filteredArray[indexPath.row].location?.latitude != nil{
                cell.layer.backgroundColor = UIColor.red.cgColor
            }
        case 1:
            cell.textLabel!.text = categoryArray[indexPath.row]
        default:
            cell.textLabel?.text = String(describing: dateArray[indexPath.row].date!).stripTime()
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 1:
            return categoryArray.count
        default:
            return filteredArray.count
        }
    }
    @IBAction func selectSegment(_ sender: AnyObject) {
        tableView.reloadData()
    }
}
