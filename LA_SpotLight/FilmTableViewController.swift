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

class FilmTableViewController : UIViewController {
  
    @IBOutlet weak var tableView:           UITableView!
    @IBOutlet weak var segmentControl:      ScrollableSegmentControl!
   
    let kCloseCellHeight: CGFloat = 76
    let kOpenCellHeight: CGFloat = 388
    
    //needs to be changed to size of filtered array
    let kRowsCount = 1000

    var currentMode: filterMode = .film
    var filteredArray =         [FilmLocation]()
    var filteredCatArray =      [String]()
    var category =              false
    var film =                  FilmLocation.self
    let yearsArray =            ["2012","2013","2014","2015","2016+"]
    var cellHeights: [CGFloat] = []
    //var cellHeights = (0..<1000).map { _ in C.CellHeight.close }
    
    override func viewDidLoad() {

        setup()
        segmentControl.segmentControlDelegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "filmCell")
        locationsArray.sort(by: {$0.production! < $1.production! })
        categoryArray.sort(by: {$0 < $1 })
        filteredArray = locationsArray
        filteredCatArray = categoryArray
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    @IBAction func mapButton(_ sender: AnyObject) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "masterMapViewController") as! MasterMapViewController
        vc.filteredArray = filteredArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FilmTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch currentMode {
        case .film:
            return filteredArray.count
        case .category:
            return filteredCatArray.count
        case .date:
            return yearsArray.count
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentMode == .film {
            return cellHeights[indexPath.row]
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
