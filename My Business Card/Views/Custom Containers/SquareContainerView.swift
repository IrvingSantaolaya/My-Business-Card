//
//  SquareContainerView.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class SquareContainerView: UIView {

    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(radius: CGFloat) {
        super.init(frame: .zero)
        layer.cornerRadius = radius
        setup()
    }
    
    // MARK: Setup UI
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.secondarySystemBackground
        } else {
            backgroundColor = .lightGray
        }
    }
}
