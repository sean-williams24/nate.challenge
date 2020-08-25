//
//  AddProductViewController.swift
//  NateChallenge
//
//  Created by Sean Williams on 25/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var merchantTextfield: UITextField!
    @IBOutlet weak var urlTextfield: UITextField!
    @IBOutlet weak var image1Textfield: UITextField!
    @IBOutlet weak var image2Textfield: UITextField!
    @IBOutlet weak var image3Textfield: UITextField!
    
    // MARK: - Properties
    
    var delegate: AddProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.borderWidth = 0.5
        addButton.layer.borderColor = UIColor.black.cgColor
        addButton.layer.cornerRadius = 5
        
        
    }
    

    
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
        
        NetworkClient().addProduct(title: titleTextfield.text ?? "", images: images, url: urlTextfield.text ?? "", merchant: merchantTextfield.text ?? "") {  newProduct in
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.delegate?.updateProducts(newProduct: newProduct)
                }
            )}
        }
    }   
}
