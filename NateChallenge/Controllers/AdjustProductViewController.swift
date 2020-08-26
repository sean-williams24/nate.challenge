//
//  AddProductViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 25/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class AdjustProductViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var merchantTextfield: UITextField!
    @IBOutlet weak var urlTextfield: UITextField!
    @IBOutlet weak var image1Textfield: UITextField!
    @IBOutlet weak var image2Textfield: UITextField!
    @IBOutlet weak var image3Textfield: UITextField!
    
    
    // MARK: - Properties
    
    var delegate: ProductsDelegate?
    var updateProductDelegate: UpdateProductDetailsDelegate?
    var product: Product!
    var editingProduct = false
    let client = NetworkClient()
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.borderWidth = 0.5
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 5
        
        if editingProduct {
            addButton.setTitle("Update Product", for: .normal)
            
            titleTextfield.text = product.title
            merchantTextfield.text = product.merchant
            urlTextfield.text = product.url
            
            if product.images.count >= 1 {
                image1Textfield.text = product.images[0]
            }
            
            if product.images.count >= 2 {
                 image2Textfield.text = product.images[1]
             }
            
            if product.images.count >= 3 {
                 image3Textfield.text = product.images[2]
             }
        }
    }
    

    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        guard !titleTextfield.text!.isEmpty else {
            return
        }
        
        var images = [String]()
        
        if !image1Textfield.text!.isEmpty {
            images.append(image1Textfield.text!)
        }
        
        if !image2Textfield.text!.isEmpty {
            images.append(image1Textfield.text!)
        }
        
        if !image3Textfield.text!.isEmpty {
            images.append(image1Textfield.text!)
        }
 
        
        if editingProduct {
            client.updateProduct(id: product.id, title: titleTextfield.text ?? "", images: images, url: urlTextfield.text ?? "", merchant: merchantTextfield.text ?? "") { updatedProduct in
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.updateProductDelegate?.updateProduct(updatedProduct: updatedProduct)
                        self.delegate?.updateProducts(newProduct: updatedProduct, updating: true)
                    }
                }
            }
        } else {
            client.addProduct(title: titleTextfield.text ?? "", images: images, url: urlTextfield.text ?? "", merchant: merchantTextfield.text ?? "") {  newProduct in
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.delegate?.updateProducts(newProduct: newProduct, updating: false)
                    }
                }
            }
        }
    }   
}
