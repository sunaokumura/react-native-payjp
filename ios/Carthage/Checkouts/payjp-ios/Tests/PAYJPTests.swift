//
//  PAYJPTests.swift
//  PAYJPTests
//

import XCTest
import PassKit
import OHHTTPStubs
@testable import PAYJP

class PAYJPTests: XCTestCase {
    override func setUp() {
        super.setUp()
        stub(condition: { (req) -> Bool in
            req.url?.host == "api.pay.jp" && req.url?.path.starts(with: "/v1/tokens") ?? false
        }) { (req) -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(jsonObject: TestFixture.JSON(by: "token.json"), statusCode: 200, headers: nil)
        }.name = "default"
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testCreateToken_withPKPaymentToken() {
        let apiClient = APIClient(publicKey: "pk_test_d5b6d618c26b898d5ed4253c")
        
        let expectation = self.expectation(description: self.description)
        
        apiClient.createToken(with: StubPaymentToken()) { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let token = try! Token.decodeValue(json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCreateToken_withCardInput() {
        OHHTTPStubs.removeAllStubs()
        stub(condition: { (req) -> Bool in
            // check request
            if let body = req.ohhttpStubs_httpBody {
                let bodyString = String.init(data: body, encoding: String.Encoding.utf8)
                XCTAssertEqual("card[number]=4242424242424242"
                    + "&card[cvc]=123"
                    + "&card[exp_month]=02"
                    + "&card[exp_year]=2020"
                    + "&card[name]=TARO YAMADA", bodyString)
                return true
            }
            return false
        }) { (req) -> OHHTTPStubsResponse in
            OHHTTPStubsResponse(jsonObject: TestFixture.JSON(by: "token.json"), statusCode: 200, headers: nil)
            }
        
        let apiClient = APIClient(publicKey: "pk_test_d5b6d618c26b898d5ed4253c")

        let expectation = self.expectation(description: self.description)
        
        apiClient.createToken(with: "4242424242424242",
                              cvc: "123",
                              expirationMonth: "02",
                              expirationYear: "2020",
                              name: "TARO YAMADA")
        { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let token = try! Token.decodeValue(json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetToken() {
        let apiClient = APIClient(publicKey: "pk_test_d5b6d618c26b898d5ed4253c")
        
        let expectation = self.expectation(description: self.description)
        
        apiClient.getToken(with: "tok_eff34b780cbebd61e87f09ecc9c6") { result in
            switch result {
            case .success(let payToken):
                let json = TestFixture.JSON(by: "token.json")
                let token = try! Token.decodeValue(json)
                
                XCTAssertEqual(payToken, token)
                expectation.fulfill()
                break
            default:
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    class StubPaymentToken: PKPaymentToken {
        override var paymentData: Data {
            return try! JSONSerialization.data(withJSONObject: TestFixture.JSON(by: "paymentData.json"), options: .prettyPrinted)
        }
    }
}
