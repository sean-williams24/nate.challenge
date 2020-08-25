//
//  NateChallengeTests.swift
//  NateChallengeTests
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import XCTest
@testable import NateChallenge

class NateChallengeTests: XCTestCase {
    
    var products: [Product] = []

    override func setUpWithError() throws {
        let iPhone = Product(title: "iPhone XS", merchant: "Apple", url: "Apple.com/store", images: ["apple.com/jpg1", "apple.com/jpg2", "apple.com/jpg3"])
        products.append(iPhone)
    }


    func testProductModel() throws {
        let product = products[0]
        
        XCTAssertEqual(product.merchant, "Apple")
        XCTAssert(product.images.count == 3, "Images does not contain array of 3 Strings")
    }



}
