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
  
    @IBOutlet weak var segmentControl:      ScrollableSegmentControl!

    let transistion = CEFoldAnimationController()

    var currentMode:            filterMode = .film

    var filteredCatArray =      [String]()
    var category =              false
    var film =                  FilmLocation.self
    
    override func viewDidLoad() {
        
        Client.sharedInstance.callAPI(endPoint: .getFilms()) {
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        //categorySet.sort({$0 < $1 })
        filteredArray = filmLocations
    }
    
    @IBAction func mapButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "masterMapViewController") as! MasterMapViewController
        vc.filteredArray = filteredArray
        vc.transitioningDelegate = self
        present(vc,animated: true, completion: nil)
    }
}

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FilmDetailCell
            let durations: [TimeInterval] = [0.26, 0.2, 0.2]
            cell.durationsForExpandedState = durations
            cell.durationsForCollapsedState = durations
            cell.film = filteredArray[indexPath.row]
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = filteredCatArray[indexPath.row]
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = yearsArray[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentMode == .film ? cellHeights[indexPath.row] : 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            
        case .category:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "filteredTableViewController") as! FilteredTableViewController
            vc.categoryString = categoryArray[indexPath.row]
            vc.filmLocations = self.filmLocations
            self.navigationController?.pushViewController(vc, animated: true)
        case .date:
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

extension FilmTableViewController: ScrollableSegmentControlDelegate {
    func segmentControl(_ segmentControl: ScrollableSegmentControl, didSelectIndex index: Int) {
        switch index {
        case 0:
            currentMode = .film
        case 1:
            currentMode = .category
        default:
            currentMode = .date
        }
        tableView.reloadData()
    }
}

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

