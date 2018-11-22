//
//  APIErrorNSErrorTests.swift
//  PAYJPTests
//
//  Created by Li-Hsuan Chen on 2018/05/23.
//  Copyright © 2018年 PAY, Inc. All rights reserved.
//

import XCTest
import PassKit
@testable import PAYJP

class APIErrorNSErrorTests: XCTestCase {
    func testInvalidApplePayTokenConversion() {
        let token = PKPaymentToken()
        let apiError = APIError.invalidApplePayToken(token)
        let nserror =  apiError.nsErrorValue()
        
        let errorToken = nserror?.userInfo[PAYErrorInvalidApplePayTokenObject] as? PKPaymentToken
        
        XCTAssertNotNil(errorToken)
        XCTAssertEqual(errorToken, token)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidApplePayToken)
        XCTAssertEqual(nserror?.localizedDescription, "Invalid Apple Pay Token")
    }
    
    func testSystemError() {
        let error = NSError(domain: "mock_domain", code: 0, userInfo: [NSLocalizedDescriptionKey: "mock error"])
        
        let apiError = APIError.systemError(error)
        let nserror =  apiError.nsErrorValue()
        
        let systemError = nserror?.userInfo[PAYErrorSystemErrorObject] as? NSError
        
        XCTAssertNotNil(systemError)
        XCTAssertEqual(systemError, error)
        
        XCTAssertEqual(nserror?.code, PAYErrorSystemError)
        XCTAssertEqual(nserror?.localizedDescription, "mock error")
    }
    
    func testInvalidResponse() {
        let response = HTTPURLResponse()
        
        let apiError = APIError.invalidResponse(response)
        let nserror =  apiError.nsErrorValue()
        
        let errorResponse = nserror?.userInfo[PAYErrorInvalidResponseObject] as? HTTPURLResponse
        
        XCTAssertNotNil(errorResponse)
        XCTAssertEqual(errorResponse, response)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidResponse)
        XCTAssertEqual(nserror?.localizedDescription, "The response is not a HTTPURLResponse instance.")
    }
    
    func testInvalidResponseBody() {
        let data = "mock data".data(using: .utf8)
        
        let apiError = APIError.invalidResponseBody(data!)
        let nserror =  apiError.nsErrorValue()
        
        let errorData = nserror?.userInfo[PAYErrorInvalidResponseData] as? Data
        
        XCTAssertNotNil(errorData)
        XCTAssertEqual(errorData, data)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidResponseBody)
        XCTAssertEqual(nserror?.localizedDescription, "The response body\'s data is not a valid JSON object.")
    }
    
    func testServiceError() {
        let json = TestFixture.JSON(by: "error.json")
        let payError = try! PAYErrorResponse.decodeValue(json, rootKeyPath: "error")
        
        let apiError = APIError.serviceError(payError)
        let nserror =  apiError.nsErrorValue()
        
        let errorObject = nserror?.userInfo[PAYErrorServiceErrorObject] as? PAYErrorResponse
        
        XCTAssertNotNil(payError)
        XCTAssertEqual(payError, errorObject)
        
        XCTAssertEqual(nserror?.code, PAYErrorServiceError)
        XCTAssertEqual(nserror?.localizedDescription, "Invalid card number")
    }
    
    func testInvalidJSON() {
        let someObject = "Not a JSON"
        
        let apiError = APIError.invalidJSON(someObject)
        let nserror =  apiError.nsErrorValue()
        
        let errorObject = nserror?.userInfo[PAYErrorInvalidJSONObject] as? String
        
        XCTAssertNotNil(someObject)
        XCTAssertEqual(someObject, errorObject)
        
        XCTAssertEqual(nserror?.code, PAYErrorInvalidJSON)
        XCTAssertEqual(nserror?.localizedDescription, "Unable parse JSON object into expected classes.")
    }
}
