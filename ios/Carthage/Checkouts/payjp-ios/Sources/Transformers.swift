//
//  Transformers.swift
//  PAYJP
//
//  Created by k@binc.jp on 10/3/16.
//  Copyright © 2016 PAY, Inc. All rights reserved.
//  
//  Himotoki Custom Transformer
//  https://github.com/ikesyo/Himotoki#value-transformation
//

import Foundation

let DateTransformer = Transformer<TimeInterval, Date> { time throws -> Date in
    return Date(timeIntervalSince1970: time)
}
