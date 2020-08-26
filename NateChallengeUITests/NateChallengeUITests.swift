//
//  NateChallengeUITests.swift
//  NateChallengeUITests
//
//  Created by Sean Williams on 24/08/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import XCTest

class NateChallengeUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    
    func testUpdateProductTextfields() {
        let app = XCUIApplication()
        app.launch()
        app.toolbars["Toolbar"].buttons["Add Product"].tap()
        
        XCTAssertEqual(app.textFields.count, 6, "Incorrect Number of Textfields")
    }
    
    
    func testUpdateProductButtonTitle() {
        let app = XCUIApplication()
        app.launch()
        app.toolbars["Toolbar"].buttons["Add Product"].tap()
        let button = app/*@START_MENU_TOKEN@*/.staticTexts["ADD PRODUCT"]/*[[".buttons[\"ADD PRODUCT\"].staticTexts[\"ADD PRODUCT\"]",".staticTexts[\"ADD PRODUCT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        XCTAssertEqual(button.label, "ADD PRODUCT")
    }
    
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
