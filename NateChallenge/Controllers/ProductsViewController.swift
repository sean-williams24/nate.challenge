//
//  ViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Kingfisher
import Spring
import UIKit

protocol ProductsDelegate {
    func updateProducts(newProduct: Product, updating: Bool)
    func deleteProduct(deletedProduct: Product)
}


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
    var selectedItem: IndexPath!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup hi there image with animation
        
        let imageView = SpringImageView(image: UIImage(named: "hi"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.animation = "slideDown"
        imageView.rotate = 40
        imageView.duration = 2
        imageView.alpha = 0
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 68).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.animateNext {
            imageView.animation = "fall"
            imageView.animate()
            
            UIView.animate(withDuration: 1) {
                self.collectionView.alpha = 1
            }
        }
        
        // Fetch all products
        
        client.getAllProducts { [weak self] newProducts in
            self?.products.append(contentsOf: newProducts)
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            vc.product = product
            vc.delegate = self
        } else {
            let vc = segue.destination as! AdjustProductViewController
            vc.delegate = self
        }
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
        selectedItem = indexPath
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


// MARK: - Product Delegates

extension ProductsViewController: ProductsDelegate {
    
    func deleteProduct(deletedProduct: Product) {
        products.removeAll(where: {$0.id == deletedProduct.id})
        collectionView.deleteItems(at: [selectedItem])
    }
    
    func updateProducts(newProduct: Product, updating: Bool) {
        if updating {
            client.getAllProducts { [weak self] updatedProducts in
                self?.products = updatedProducts
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.products.insert(newProduct, at: 0)
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}
