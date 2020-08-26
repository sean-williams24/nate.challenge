//
//  Product.swift
//  NateChallenge
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

struct Posts: Codable {
    let posts: [Product]
}

struct Product: Codable {
    let title: String
    let merchant: String
    let url: String
    let images: [String]
    let id: String
}
