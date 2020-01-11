//
//  UIView+Extensions.swift
//  QRDS
//
//  Created by Irving Martinez on 1/11/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

extension UIView {
    func dropShadow(scale: Bool = true, color: UIColor) {

        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
