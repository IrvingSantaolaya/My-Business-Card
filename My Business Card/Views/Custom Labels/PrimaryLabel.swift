//
//  PrimaryLabel.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class PrimaryLabel: UILabel {

    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    // MARK: Setup UI
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .title1)
        textAlignment = .left
        numberOfLines = 0
        if #available(iOS 13.0, *) {
            textColor = .label
        } else {
            textColor = .black
        }
    }
}
