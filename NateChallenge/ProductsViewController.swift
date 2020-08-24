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
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    let itemsPerRow: CGFloat = 2.0
    
    
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
        
        if product.images != [] {
            if let url = URL(string: product.images[0]) {
                
                
                
                if let imageData = try? Data(contentsOf: url) {
                    cell.imageView.image = UIImage(data: imageData)
                }
            }
        }


        
        return cell
    }
}


extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
