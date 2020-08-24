//
//  ViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURL = URL(string: "http://192.168.0.14:3000/products")
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = """
//        {
//            "where": {
//                "title": {
//                    "contains": ""
//                }
//            }
//        }
//        """.data(using: .utf8)

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(Posts.self, from: data!)
                for prod in result.posts {
                    print(prod)
                }
                
            } catch {
                print(error.localizedDescription as Any)
            }
            
        }.resume()
        
        
        
    }

    
}

