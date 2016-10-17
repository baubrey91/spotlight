//
//  ServiceCall.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/27/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//

import Foundation

var locationsArray = [FilmLocation]()
var categoryArray = [String]()

func getServices(){
    let urlString = "https://data.weho.org/resource/q9u3-sn3t.json"
    
    let url = URL(string: urlString)
    
    let data = try? Data(contentsOf: url!)
    
    let categorySet = NSMutableSet()

    do {
        let JSON = try JSONSerialization.jsonObject(with: data!, options: [])
        let jsonDict = JSON as? [[String:Any]]
        for obj in jsonDict!{
            let fl = FilmLocation(json: obj)
            locationsArray.append(fl!)
            categorySet.add(obj["category"]!)
        }
        categoryArray = (categorySet.allObjects as NSArray) as! [String]
        
    } catch {
        print("Error: \(error)")
    }

 /*   URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print("error")
            return
        }
        DispatchQueue.main.async {
            let JSON = try JSONSerialization.jsonObject(with: data!, options: [])
            let jsonDict = JSON as? [[String:Any]]
            for obj in jsonDict!{
                let fl = FilmLocation(json: obj)
                locationsArray.append(fl!)
                categorySet.add(obj["category"]!)
            }
            categoryArray = (categorySet.allObjects as NSArray) as! [String]
        }*/
    
   /* let config = URLSessionConfiguration.default // Session Configuration
    let session = URLSession(configuration: config) // Load configuration into Session
    let url2 = URL(string: "https://data.weho.org/resource/q9u3-sn3t.json")!
    
    let task = session.dataTask(with: url2, completionHandler: {
        (data, response, error) in
        
        if error != nil {
            
            print(error!.localizedDescription)
            
        } else {
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]]
                {
                    
                    let jsonDict = json as? [[String:Any]]
                    for obj in jsonDict!{
                        let fl = FilmLocation(json: obj)
                        locationsArray.append(fl!)
                        categorySet.add(obj["category"]!)
                    }
                    categoryArray = (categorySet.allObjects as NSArray) as! [String]

                    //Implement your logic
                    print(json)
                    
                }
                
            } catch {
                
                print("error in JSONSerialization")
                
            }
            
            
        }
        
    })
    task.resume()*/
}
