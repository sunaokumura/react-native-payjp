//
//  Card.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//
//  https://pay.jp/docs/api/#token-トークン
//
//

import Foundation

@objcMembers @objc(PAYCard) public final class Card: NSObject {
    public let identifer: String
    public let name: String?
    public let last4Number: String
    public let brand: String
    public let expirationMonth: UInt8
    public let expirationYear: UInt16
    public let fingerprint: String
    public let liveMode: Bool
    public let createdAt: Date
    public let rawValue: Any
    
    init(_ e: Extractor) {
        identifer = try! e <| "id"
        name = try! e <|? "name"
        last4Number = try! e <| "last4"
        brand = try! e <| "brand"
        expirationMonth = try! e <| "exp_month"
        expirationYear = try! e <| "exp_year"
        fingerprint = try! e <| "fingerprint"
        liveMode = try! e <| "livemode"
        createdAt = try! DateTransformer.apply(e <| "created")
        rawValue = e.rawValue
    }
}

extension Card: Decodable {
    public static func decode(_ e: Extractor) throws -> Self {
        return try castOrFail(Card(e))
    }
}

public enum CardBrand: String, Decodable {
    case visa = "Visa"
    case masterCard = "MasterCard"
    case JCB = "JCB"
    case amex = "American Express"
    case dinersClub = "Diners Club"
    case discover = "Discover"
    
    func display() -> String {
        return String(describing: self).uppercased()
    }
}
