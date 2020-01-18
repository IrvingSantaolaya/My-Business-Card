//
//  MainTextField.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class PrimaryTextField: UITextField {

    // MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setup()
    }
    
    // MARK: Setup UI
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 1
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .headline)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        autocorrectionType = .no
        
        if #available(iOS 13.0, *) {
            layer.borderColor = UIColor.systemGray4.cgColor
            backgroundColor = .tertiarySystemBackground
            textColor = .label
            tintColor = .label
        } else {
            layer.borderColor = UIColor.gray.cgColor
            textColor = .black
            backgroundColor = .lightGray
        }
        
    }

}
