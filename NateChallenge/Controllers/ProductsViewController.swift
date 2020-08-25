//
//  ViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Kingfisher
import UIKit

class ProductsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    // MARK: - Properties

    var products: [Product] = []
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    let itemsPerRow: CGFloat = 2.0
    var product: Product!
    private let client = NetworkClient()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        client.getAllProducts { newProducts in
            self.products.append(contentsOf: newProducts)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
 
    }
    
    
    
    // MARK: - Helper Methods
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        vc.product = product
    }

    
    // MARK: - Actions

    @IBAction func addProductTapped(_ sender: Any) {
        
        let baseURL = URL(string: "http://192.168.0.14:3000/product/create")!

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = """
        {
            "title": "Glenns Gin",
            "images": ["https://images-na.ssl-images-amazon.com/images/I/51dhaObEFuL._AC_SL1000_.jpg"],
            "url": "https://www.amazon.co.uk/Brockmans-9-OG-001-40-Gin-70-cl/dp/B008HKMK8U?ref_=Oct_s9_apbd_orecs_hd_bw_bN46V5&pf_rd_r=KVNMAT9XQ61YHD4A8G8R&pf_rd_p=5da95452-8b42-5205-9b47-71a46263622f&pf_rd_s=merchandised-search-10&pf_rd_t=BROWSE&pf_rd_i=340834031",
            "merchant": "Amazon"
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
                
                DispatchQueue.main.async {
                    self.products.insert(newProduct, at: 0)
                    self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
        
        var heading = product.merchant == "" ? product.title : product.merchant
        
        if heading.hasPrefix("www.") { heading.removeFirst(4) }
        if heading.hasSuffix(".com") { heading.removeLast(4)}
        cell.titleLabel.text = heading

        // Download, set and cache image
        if product.images != [] {
            let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100))
            var urlStr = product.images[0]
            
            if urlStr.hasPrefix("//") {
                urlStr.insert(contentsOf: "http:", at: urlStr.startIndex)
            }
            
            cell.imageView.kf.setImage(
                with: URL(string: urlStr),
                placeholder: UIImage(named: "nate"),
                options: [
                    .processor(processor),
                    .transition(.fade(0.4)),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])
        } else {
            cell.imageView.image = UIImage(named: "nate")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        product = products[indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > collectionView.contentSize.height - scrollView.frame.size.height + toolbar.frame.height - 100 {
            guard !client.isPaginating else {
                return
            }
            
            client.getAllProducts(pagination: true) { newProducts in
                self.products.append(contentsOf: newProducts)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}


// MARK: - Collection View Flow Layout Delegates

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
