//
//  tableViewBaseViewController.swift
//  LA_SpotLight
//
//  Created by Brandon on 9/28/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import Foundation
import UIKit

class TableViewBaseViewController: UIViewController {
    
    //-------------------------//
    //MARK:- Variables
    //-------------------------//
    
    @IBOutlet weak var tableView: UITableView!

    var filmLocations = [FilmLocation]()
    var filteredArray = [FilmLocation]() {
        didSet {
            animateTableView()
            //cellHeights = Array(repeating: kCloseCellHeight, count: filteredArray.count)
            //kRowsCount = filteredArray.count
        }
    }
    
    let kCloseCellHeight: CGFloat = 76
    let kOpenCellHeight: CGFloat = 263
    var cellHeights: [CGFloat] = []
    
    //needs to be changed to size of filtered array
    //var kRowsCount = 25

    //------------------------------//
    //Functions
    //------------------------------//
    
    func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: 1000)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func animateTableView() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            
        }
        var index = 0
        
        for cell in cells {
            let cell: UITableViewCell = cell as UITableViewCell
            
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: [], animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            
            index += 1
        }
    }
}

    //-------------------------//
    //MARK:- Table View 
    //-------------------------//

extension TableViewBaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingCell = cell else {
            return
        }
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cCells.foldingCell, for: indexPath) as! FilmDetailCell
        cell.durationsForExpandedState = cCells.durations
        cell.durationsForCollapsedState = cCells.durations
        cell.film = filteredArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
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
            cell.unfold(true, animated: true, completion: nil)
            duration = cCells.unfoldDuration
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = cCells.foldDuration
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}
