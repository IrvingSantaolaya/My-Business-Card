//
//  ReceivedCard.swift
//  QRDS
//
//  Created by Irving Martinez on 1/3/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import Foundation

protocol CardReceivable {
    func gotCard(card: Card)
}
