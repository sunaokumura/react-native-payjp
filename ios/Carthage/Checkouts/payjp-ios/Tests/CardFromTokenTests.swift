//
//  CardFromTokenTests.swift
//  PAYJP
//
//  Created by k@binc.jp on 2017/01/05.
//  Copyright © 2017 PAY, Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import PAYJP

class CardFromTokenTests: XCTestCase {
    var card: Card!
    
    override func setUp() {
        let json = TestFixture.JSON(by: "token.json")
        let token = try! Token.decodeValue(json)
        card = token.card
    }
    
    func testCardProperties() {
        XCTAssertEqual(card.brand, "Visa")
    }
    
    func testNameIsNullable() {
        XCTAssertNil(card.name)
    }
}
