//
//  PAYErrorResponseTests.swift
//  PAYJP
//
//  Created by Li-Hsuan Chen on 2018/05/21.
//  Copyright © 2018年 PAY, Inc. All rights reserved.
//

import Foundation

import Foundation
import XCTest
@testable import PAYJP

class PAYErrorResponseTests: XCTestCase {
    var errorResponse: PAYErrorResponse!
    
    override func setUp() {
        let json = TestFixture.JSON(by: "error.json")
        errorResponse = try! PAYErrorResponse.decodeValue(json, rootKeyPath: "error")
    }
    
    func testErrorProperties() {
        XCTAssertEqual(errorResponse.status, 402)
        XCTAssertEqual(errorResponse.message, "Invalid card number")
        XCTAssertEqual(errorResponse.param, "card[number]")
        XCTAssertEqual(errorResponse.code, "invalid_number")
        XCTAssertEqual(errorResponse.type, "card_error")
    }
}
