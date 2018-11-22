//
//  Token.swift
//  PAYJP
//
//  Created by k@binc.jp on 9/29/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//
//  https://pay.jp/docs/api/#token-トークン
//

import Foundation

@objcMembers @objc(PAYToken) public final class Token: NSObject {
    public let identifer: String
    public let livemode: Bool
    public let used: Bool
    public let card: Card
    public let createdAt: Date
    public let rawValue: Any
 
    init (_ e: Extractor) {
        identifer = try! e <| "id"
        livemode = try! e <| "livemode"
        used = try! e <| "used"
        card = try! e <| "card"
        createdAt = try! DateTransformer.apply(e <| "created")
        rawValue = e.rawValue
    }
}

extension Token: Decodable {
    public static func decode(_ e: Extractor) throws -> Self {
        return try castOrFail(Token(e))
    }
}

extension Token {
    public override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Token {
            return self.identifer == object.identifer
        }
        
        return false
    }
}
