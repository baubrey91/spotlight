//
//  Client.swift
//  LA_SpotLight
//
//  Created by Brandon on 9/25/17.
//  Copyright © 2017 Brandon Aubrey. All rights reserved.
//

import Foundation

fileprivate let http = "https://"
fileprivate let base = "data.weho.org/"
fileprivate let resources = "resource/"
fileprivate let filmPermits = "q9u3-sn3t.json"

enum Endpoint {
    case getFilms()
    var url: String {
        switch self {
        case .getFilms():
            return http + base + resources + filmPermits
        }
    }
}

class Client {
    static let sharedInstance = Client()
    fileprivate let session = URLSession.shared
    
    func callAPI(endPoint: Endpoint, completionHandler: @escaping ((_ assignemnts: Any) -> Void)) {
        if let url = URL(string: endPoint.url) {
            let task = session.dataTask(with: url,
                                        completionHandler: { data, response, error -> Void in
                                            if let error = error {
                                                print(error)
                                            }
                                            else if let data = data {
                                                let jsonData = (try? JSONSerialization.jsonObject(with: data,
                                                                                                  options: JSONSerialization.ReadingOptions.allowFragments)) as? [payload]
                                                completionHandler(jsonData ?? [payload]())
                                            }
                                            self.session.invalidateAndCancel()
            })
            task.resume()
        }
    }
}
