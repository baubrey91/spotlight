//
//  FilmTableViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/29/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

enum filterMode {
    case film
    case category
    case date
}

class FilmTableViewController: TableViewBaseViewController {
  
    //----------------------//
    //MARK:- VARIABLES
    //----------------------//
    
    @IBOutlet weak var segmentControl:      ScrollableSegmentControl!
    
    let transistion =           CEFoldAnimationController()
    var searchBar:              UISearchBar!
    var currentMode:            filterMode = .film
    var filteredCatArray =      [String]()
    var category =              false
    var film =                  FilmLocation.self
   
    //----------------------//
    //MARK:- VIEW LIFE CYCLE
    //----------------------//
    
    override func viewDidLoad() {
        
        Client.sharedInstance.callAPI(endPoint: .getFilms()) { [unowned self]
            json in DispatchQueue.main.async {
                self.filmLocations = FilmLocation.filmLocations(array: json as! [payload])
                self.filmLocations.sort(by: { $0.production! < $1.production! })
                self.filteredArray = self.filmLocations
                self.filteredCatArray = categoryArray
                //self.tableView.reloadData()
            }
        }
        
        setup()
        segmentControl.segmentControlDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cells.filmCell)
        //categorySet.sort({$0 < $1 })
        filteredArray = filmLocations
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    //----------------------//
    //MARK:- IBACTIONS
    //----------------------//

    @IBAction func mapButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: storyboards.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboards.map) as! MasterMapViewController
        vc.filteredArray = filteredArray
        vc.transitioningDelegate = self
        present(vc,animated: true, completion: nil)
    }
}
 
    //----------------------//
    //MARK:- TableView
    //----------------------//

extension FilmTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch currentMode {
        case .film:
            return filteredArray.count
        case .category:
            return filteredCatArray.count
        case .date:
            return yearsArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
                
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMode {
        case .film:
            let cell = tableView.dequeueReusableCell(withIdentifier: cells.foldingCell, for: indexPath) as! FilmDetailCell
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            cell.film = filteredArray[indexPath.row]
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: cells.filmCell, for: indexPath) as UITableViewCell
            cell.textLabel?.text = filteredCatArray[indexPath.row]
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: cells.filmCell, for: indexPath) as UITableViewCell
            cell.textLabel?.text = yearsArray[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentMode == .film ? cellHeights[indexPath.row] : 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: storyboards.main, bundle: nil)
        
        switch currentMode {
        case .film:
            let cell = tableView.cellForRow(at: indexPath) as! FilmDetailCell
            if cell.isAnimating() {
                return
            }
            
            var duration = 0.0
            let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
            if cellIsCollapsed {
                
                cellHeights[indexPath.row] = kOpenCellHeight
                cell.unfold(true)
                duration = 1.0
            } else {
                cellHeights[indexPath.row] = kCloseCellHeight
                cell.unfold(false)
                duration = 1.2
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
                tableView.beginUpdates()
                tableView.endUpdates()
            }, completion: nil)
            
        case .category:
            let vc = storyboard.instantiateViewController(withIdentifier: storyboards.filteredTBC) as! FilteredTableViewController
            vc.categoryString = categoryArray[indexPath.row]
            vc.filmLocations = self.filmLocations
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .date:
            let vc = storyboard.instantiateViewController(withIdentifier: storyboards.filteredDatesTBC) as! FilteredDatesTableViewController
            if indexPath.row == 4 {
                vc.year = 2016
            } else {
                vc.year = Int(yearsArray[indexPath.row])!
            }
            vc.filmLocations = filmLocations
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

    //----------------------//
    //MARK:- SegmentController
    //----------------------//

extension FilmTableViewController: ScrollableSegmentControlDelegate {
    func segmentControl(_ segmentControl: ScrollableSegmentControl, didSelectIndex index: Int) {
        switch index {
        case 0:
            searchBar.isHidden = false
            currentMode = .film
        case 1:
            searchBar.isHidden = false
            currentMode = .category
        default:
            searchBar.isHidden = true
            currentMode = .date
        }
        tableView.reloadData()
    }
}

    //----------------------//
    //MARK:- Transition
    //----------------------//

extension FilmTableViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transistion.reverse = false
        return transistion
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transistion.reverse = true
        return transistion
    }
}

    //----------------------//
    //MARK:- SearchBar
    //----------------------//

extension FilmTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        switch currentMode {
        case .film:
            
            filteredArray.removeAll()
            if searchText.characters.count > 0 {
                filteredArray = filmLocations.filter {
                    ($0.production?.contains(searchText))!
                }
            }
            else {
                filteredArray.append(contentsOf: filmLocations)
            }
        case .category:
            
            filteredCatArray.removeAll()
            if searchText.characters.count > 0 {
                filteredCatArray = categoryArray.filter {
                    ($0.contains(searchText))
                }
            }
            else {
                filteredCatArray.append(contentsOf: categoryArray)
            }
        case .date:
            break
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
    } 
}
