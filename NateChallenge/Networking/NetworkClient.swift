//
//  NetworkClient.swift
//  NateChallenge
//
//  Created by Sean Williams on 25/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

class NetworkClient {
    
    var isPaginating = false
    
    func getAllProducts(pagination: Bool = false, completion: @escaping ([Product]) -> ()) {
        let baseURL = URL(string: "http://192.168.0.14:3000/products")
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"

        if pagination {
            isPaginating = true
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(Posts.self, from: data!)
                completion(result.posts)
                if pagination {
                    self.isPaginating = false
                }

            } catch {
                print(error.localizedDescription as Any)
            }
        }.resume()
    }
}




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
