//
//  Constants.swift
//  LA_SpotLight
//
//  Created by Brandon on 9/25/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import Foundation

typealias payload = [String: Any]

var categoryArray = [String]()
let yearsArray =  ["2012","2013","2014","2015","2016+"]
let df = DateFormatter()

struct cStoryboards {
    static let main = "Main"
    static let filteredTBC = "filteredTableViewController"
    static let filteredDatesTBC = "filteredDatesTableViewController"
    static let map = "masterMapViewController"
}

struct cCells {
    static let foldingCell = "FoldingCell"
    static let filmCell = "filmCell"
}

struct cFilmLocation {
    static let category = "category"
    //static let filmCell = "filmCell"
}

struct cDate {
    static let janFirst = "-01-01"
}
