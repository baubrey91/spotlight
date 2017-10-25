//
//  Utils.swift
//  LA_SpotLight
//
//  Created by Brandon on 10/25/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import Foundation


class Alert {
    
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
}

extension String {
    func stripTime() -> String{
        return self[(self.startIndex)..<(self.index((self.startIndex), offsetBy: 10))]
    }
}
