//
//  ViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Properties

    var products: [Product] = []
    
    
    // MARK: - Life Cycle

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
                self.products = result.posts
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                print(error.localizedDescription as Any)
            }
            
        }.resume()
        
        
        
    }
    
}


// MARK: - Collection View Data Source

extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product cell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.row]
        
        cell.titleLabel.text = product.title
        
        return cell
    }
    
}
