//
//  DetailViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 25/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Outputs
    
    @IBOutlet var visualEfectView: UIVisualEffectView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - Properties
    
    var product: Product!
    var images = [UIImage]()

    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 10
        
        if product.images != [] {
            DispatchQueue.global(qos: .background).async {
                for imageStr in self.product.images {
                    if let url = URL(string: imageStr) {
                        if let imageData = try? Data(contentsOf: url) {
                            if let image = UIImage(data: imageData) {
                                self.images.append(image)
                                print(self.images.count)

                            }
                        }
                    }
                }
            }
        }
    }
    

    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
