//
//  SwiftUITests.swift
//  SwiftUITests
//
//  Created by 斉藤 祐輔 on 2014/09/11.
//  Copyright (c) 2014年 JIBUNSTYLE, Inc. All rights reserved.
//

import UIKit
import XCTest

class SwiftUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
