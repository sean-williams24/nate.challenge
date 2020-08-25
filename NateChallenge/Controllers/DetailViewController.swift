//
//  DetailViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 25/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Kingfisher
import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outputs
    
    @IBOutlet var visualEfectView: UIVisualEffectView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var merchantTextview: UITextView!
    @IBOutlet weak var titleTextview: UITextView!
    
    
    // MARK: - Properties
    
    var product: Product!
    var images = [UIImage]()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 10
        collectionView.layer.cornerRadius = 10
        
        merchantTextview.text = product.merchant
        titleTextview.text = product.title
        
        if product.images == [] || product.images[0] == "none" {
            images.append(UIImage(named: "nate")!)
        } else {
            DispatchQueue.global(qos: .background).async {
                for var urlStr in self.product.images {
                    
                    if urlStr.hasPrefix("//") {
                        urlStr.insert(contentsOf: "http:", at: urlStr.startIndex)
                    }
                    
                    if let url = URL(string: urlStr) {
                        if let imageData = try? Data(contentsOf: url) {
                            if let image = UIImage(data: imageData) {
                                self.images.append(image)
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                    self.pageControl.numberOfPages = self.images.count
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / popupView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    

    
    // MARK: - Actions

    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func visitWebsiteTapped(_ sender: Any) {
        guard let url = URL(string: product.url) else {
            print("Invalid URL")
            return
        }
        
        UIApplication.shared.open(url, options: [.universalLinksOnly: false]) 
    }
    

}

// MARK: - Collection View Data Source

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.imageView.image = images[indexPath.row]

        
        return cell
    }
    
    
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        product = products[indexPath.row]
//        performSegue(withIdentifier: "showDetail", sender: self)
//    }
    

}


// MARK: - Collection View Flow Layout Delegates

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: popupView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}