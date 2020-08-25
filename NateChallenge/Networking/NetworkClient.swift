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
    let baseURL = "http://192.168.0.14:3000/"
    
    
    func getAllProducts(pagination: Bool = false, completion: @escaping ([Product]) -> ()) {
        let url = URL(string: baseURL + "products")!
        var request = URLRequest(url: url)
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
    
    func addProduct(title: String, images: [String], url: String, merchant: String, completion: @escaping (Product) -> ()) {
        let addURL = URL(string: baseURL + "product/create")!
        var request = URLRequest(url: addURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
        {
            "title": "\(title)",
            "images": \(images),
            "url": "\(url)",
            "merchant": "\(merchant)"
        }
        """.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let newProduct = try decoder.decode(Product.self, from: data!)
                completion(newProduct)                
            } catch {
                print(error.localizedDescription as Any)
            }
        }.resume()
    }
}


