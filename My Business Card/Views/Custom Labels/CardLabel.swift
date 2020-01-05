//
//  CardLabel.swift
//  QRDS
//
//  Created by Irving Martinez on 1/4/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class CardLabel: UILabel {

        override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.preferredFont(forTextStyle: .body)
        textAlignment = .left
        numberOfLines = 1
        if #available(iOS 13.0, *) {
            textColor = .label
        } else {
            textColor = .black
        }
    }

}
