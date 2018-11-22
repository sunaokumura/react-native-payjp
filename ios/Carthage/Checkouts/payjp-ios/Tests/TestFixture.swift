//
//  TestHelper.swift
//  PAYJP
//
//  Created by k@binc.jp on 2017/01/05.
//  Copyright © 2017 PAY, Inc. All rights reserved.
//

import Foundation

struct TestFixture {
    private static let bundle = Bundle(identifier: "jp.pay.ios.PAYJPTests")!
    
    static func JSON(by name: String) -> Any {
        let url = self.bundle.url(forResource: name, withExtension: nil, subdirectory: "Fixtures", localization: nil)
        let data = try! Data(contentsOf: url!)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        return json
    }
}
