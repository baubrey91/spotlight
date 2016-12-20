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
    var filteredArray =         [FilmLocation]()
    var filteredCatArray =      [String]()
    var category =              false
    var film =                  FilmLocation.self
    let yearsArray =            ["2012","2013","2014","2015","2016+"]
    
    override func viewDidLoad() {

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        categoryArray.sort(by: {$0 < $1 })
        filteredArray = locationsArray
        filteredCatArray = categoryArray

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            return filteredArray.count
        case 1:
            return filteredCatArray.count
        default:
            return yearsArray.count
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
        case 1:
            cell.textLabel!.text = filteredCatArray[indexPath.row]
            cell.imageView?.image = UIImage(named: "cameraIcon")
            cell.imageView?.isHidden = false
            
        default:
            cell.textLabel?.text = yearsArray[indexPath.row]
            cell.imageView?.image = UIImage(named: "calendarIcon")
            cell.imageView?.isHidden = false
        }
        return cell
        
    }
}

extension FilmTableViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch segmentController.selectedSegmentIndex {
            
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mapViewController") as! MapViewController
            vc.film = filteredArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "filteredTableViewController") as! FilteredTableViewController
            vc.categoryString = categoryArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "filteredDatesTableViewController") as! FilteredDatesTableViewController
            if indexPath.row == 4 {
                vc.year = 2016
            } else {
                vc.year = Int(yearsArray[indexPath.row])!
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FilmTableViewController :  UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    

        switch segmentController.selectedSegmentIndex{
        case 0:
            
            filteredArray.removeAll()
            if searchText.characters.count > 0 {
                filteredArray = locationsArray.filter {
                    ($0.production?.contains(searchText))!
                }
            }
            else {
                filteredArray.append(contentsOf: locationsArray)
            }
        case 1:
            
            filteredCatArray.removeAll()
            if searchText.characters.count > 0 {
                filteredCatArray = categoryArray.filter {
                    ($0.contains(searchText))
                }
            }
            else {
                filteredCatArray.append(contentsOf: categoryArray)
            }
        default:
            break
            
        }
        tableView.reloadData()
    }
}
