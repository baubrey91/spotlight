//
//  ViewController.swift
//  LA_SpotLight
//
//  Created by Brandon Aubrey on 9/27/16.
//  Copyright © 2016 Brandon Aubrey. All rights reserved.
//


//UISearchController
//searchbar in map
//toolbar mapping

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        serviceCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {

            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            //serviceCall()
            //getServices()
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func loginButton(_ sender: AnyObject) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        serviceCall()
    }
    func serviceCall(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://data.weho.org/resource/q9u3-sn3t.json")!
        let categorySet = NSMutableSet()

        
        let task = session.dataTask(with: url, completionHandler: {
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

                        DispatchQueue.main.sync {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
                            self.activityIndicator.stopAnimating()
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
}

