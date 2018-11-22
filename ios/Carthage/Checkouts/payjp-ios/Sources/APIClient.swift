//
//  PAY.JP APIClient.swift
//  https://pay.jp/docs/api/
//

import Foundation
import PassKit

@objc(PAYAPIClient) public class APIClient: NSObject {
    /// Able to set the locale of the error messages. We provide messages in Japanese and English. Default is nil.
    @objc public var locale: Locale?
    
    private let publicKey: String
    private let baseURL: String = "https://api.pay.jp/v1"
    
    private lazy var authCredential: String = {
        let credentialData = "\(self.publicKey):".data(using: .utf8)!
        let base64Credential = credentialData.base64EncodedString()
        return "Basic \(base64Credential)"
    }()

    @objc public init(publicKey: String) {
        self.publicKey = publicKey
    }
    
    public typealias APIResponse = Result<Token, APIError>
    
    private func createToken(
        with request: URLRequest,
        completionHandler: @escaping (APIResponse) -> ())
    {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, res, err) in
            if let e = err {
                completionHandler(.failure(.systemError(e)))
                return
            }
            
            guard let response = res as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse(nil)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidResponse(response)))
                return
            }
            
            var json: Any
            do {
                json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
            } catch {
                completionHandler(.failure(.invalidResponseBody(data)))
                return
            }
            
            if response.statusCode != 200 {
                if let error = try? PAYErrorResponse.decodeValue(json, rootKeyPath: "error") {
                    completionHandler(.failure(.serviceError(error)))
                    return
                } else {
                    completionHandler(.failure(.invalidJSON(json)))
                }
            }
            
            do {
                let token = try Token.decodeValue(json)
                completionHandler(.success(token))
            } catch {
                completionHandler(.failure(.invalidJSON(json)))
            }
        })
        
        task.resume()
    }
    
    /// Create PAY.JP Token
    /// - parameter token: ApplePay Token
    public func createToken(
        with token: PKPaymentToken,
        completionHandler: @escaping (APIResponse) -> ())
    {
        guard let url = URL(string: "\(baseURL)/tokens") else { return }
        guard let body = String(data: token.paymentData, encoding: String.Encoding.utf8)?
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
                completionHandler(.failure(.invalidApplePayToken(token)))
                return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = "card=\(body)".data(using: .utf8)
        req.setValue(authCredential, forHTTPHeaderField: "Authorization")
        req.setValue(locale?.languageCode, forHTTPHeaderField: "Locale")
        
        createToken(with: req, completionHandler: completionHandler)
    }

    /// Create PAY.JP Token
    /// - parameter cardNumber:         Credit card number `1234123412341234`
    /// - parameter cvc:                Credit card cvc e.g. `123`
    /// - parameter expirationMonth:    Credit card expiration month `01`
    /// - parameter expirationYear:     Credit card expiration year `2020`
    /// - parameter name:               Credit card holder name `TARO YAMADA`
    public func createToken(
        with cardNumber: String,
        cvc: String,
        expirationMonth: String,
        expirationYear: String,
        name: String? = nil,
        completionHandler: @escaping (APIResponse) -> ())
    {
        guard let url = URL(string: "\(baseURL)/tokens") else { return }
        var formString = "card[number]=\(cardNumber)"
            + "&card[cvc]=\(cvc)"
            + "&card[exp_month]=\(expirationMonth)"
            + "&card[exp_year]=\(expirationYear)"
        if let name = name {
            formString += "&card[name]=\(name)"
        }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = formString.data(using: .utf8)
        req.setValue(authCredential, forHTTPHeaderField: "Authorization")
        req.setValue(locale?.languageCode, forHTTPHeaderField: "Locale")
        
        createToken(with: req, completionHandler: completionHandler)
    }

    /// GET PAY.JP Token
    /// - parameter tokenId:    identifier of the Token
    public func getToken(
        with tokenId: String,
        completionHandler: @escaping (APIResponse) -> ())
    {
        guard let url = URL(string: "\(baseURL)/tokens/\(tokenId)") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue(authCredential, forHTTPHeaderField: "Authorization")
        req.setValue(locale?.languageCode, forHTTPHeaderField: "Locale")
        
        createToken(with: req, completionHandler: completionHandler)
    }
}

// Objective-C API
extension APIClient {
    @objc public func createTokenWith(
        _ token: PKPaymentToken,
        completionHandler: @escaping (NSError?, Token?) -> ()) {
        
        self.createToken(with: token) { (response) in
            switch response {
            case .success(let token):
                completionHandler(nil, token)
            case .failure(let error):
                completionHandler(error.nsErrorValue(), nil)
            }
        }
    }

    @objc public func createTokenWith(
        _ cardNumber: String,
        cvc: String,
        expirationMonth: String,
        expirationYear: String,
        name: String?,
        completionHandler: @escaping (NSError?, Token?) -> ()) {
        
        self.createToken(with: cardNumber,
                         cvc: cvc,
                         expirationMonth: expirationMonth,
                         expirationYear: expirationYear,
                         name: name)
        { (response) in
            switch response {
            case .success(let token):
                completionHandler(nil, token)
            case .failure(let error):
                completionHandler(error.nsErrorValue(), nil)
            }
        }
    }

    @objc public func getTokenWith(
        _ tokenId: String,
        completionHandler: @escaping (NSError?, Token?) -> ()) {
        
        self.getToken(with: tokenId) { (response) in
            switch response {
            case .success(let token):
                completionHandler(nil, token)
            case .failure(let error):
                completionHandler(error.nsErrorValue(), nil)
            }
        }
    }
}
