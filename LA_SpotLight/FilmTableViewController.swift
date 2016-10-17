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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var filteredArray = [FilmLocation]()
    var dateArray = [FilmLocation]()
    var category = false
    var film = FilmLocation.self
    
    override func viewDidLoad() {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        serviceCall()
       
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        dateArray = locationsArray
        categoryArray.sort(by: {$0 < $1 })
        dateArray.sort(by: {$0.date?.compare($1.date as! Date) == ComparisonResult.orderedAscending })
        filteredArray = locationsArray
    }
    
    func serviceCall(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url2 = URL(string: "https://data.weho.org/resource/q9u3-sn3t.json")!
        let categorySet = NSMutableSet()
        
        
        let task = session.dataTask(with: url2, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]]
                    {
                        let jsonDict = json
                        for obj in jsonDict{
                            let fl = FilmLocation(json: obj)
                            locationsArray.append(fl!)
                            categorySet.add(obj["category"]!)
                        }
                        categoryArray = (categorySet.allObjects as NSArray) as! [String]
                        
                        self.filteredArray = locationsArray
                        self.viewDidLoad()
                       /* DispatchQueue.main.sync {
                            self.filteredArray = locationsArray
                            self.viewDidLoad()
                            //self.tableView.reloadData()
                            
                          /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
                            self.activityIndicator.stopAnimating()
                            self.present(vc, animated: true, completion: nil)*/
                        }*/
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
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



