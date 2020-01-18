//
//  MainButton.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {

    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(color: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = color
        self.setTitle(title, for: .normal)
        setup()
        dropShadow(color: color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup UI
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        layer.masksToBounds = false
    }
}
