//
//  FilmTableViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/29/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class FilmTableViewController : UIViewController {
  
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
    
    @IBAction func mapButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "masterMapViewController") as! MasterMapViewController
        vc.filteredArray = filteredArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FilmTableViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage(named: "mapIcon")
        cell.imageView?.isHidden = true
        switch segmentController.selectedSegmentIndex {
        case 0:
            cell.textLabel!.text = filteredArray[indexPath.row].production
            cell.imageView?.isHidden = (filteredArray[indexPath.row].location?.latitude != nil) ?
                false :
                true
            if filteredArray[indexPath.row].location?.latitude != nil {
            }
        case 1:
            cell.textLabel!.text = categoryArray[indexPath.row]
            
        default:
            cell.textLabel?.text = String(describing: dateArray[indexPath.row].date!).stripTime()
            cell.imageView?.isHidden = (dateArray[indexPath.row].location?.latitude != nil) ?
                false :
                true
        }
        return cell
        
    }
}

extension FilmTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch segmentController.selectedSegmentIndex {
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "filteredTableViewController") as! FilteredTableViewController
            vc.categoryString = categoryArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
            vc.film = filteredArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

extension FilmTableViewController :  UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        filteredArray.removeAll()
        switch segmentController.selectedSegmentIndex{
        case 0:
            if searchText.characters.count > 0 {
                filteredArray = locationsArray.filter {
                    ($0.production?.contains(searchText))!
                }
            }
            else {
                filteredArray.append(contentsOf: locationsArray)
            }
        case 1:
            break
        default:
            break
         /*   if searchText.characters.count > 0 {
                filteredArray = locationsArray.filter {
                    ($0.date?.contains(searchText))!
                }
            }
            else {
                filteredArray.append(contentsOf: locationsArray)
            }*/
            
        }
        tableView.reloadData()

    }
}



