//
//  RandomValue.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/6/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
