//
//  CardCell.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellUI() {
        // Content view border and rounded corners
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowColor = UIColor.black.cgColor
        
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = UIColor.systemIndigo
            contentView.layer.borderColor = UIColor.systemGray.cgColor
        } else {
            contentView.backgroundColor = .lightGray
            contentView.layer.borderColor = UIColor.darkGray.cgColor
        }
        contentView.layer.masksToBounds = true
        
        // Colored view rounded corners
        backgroundColor = .clear
    }
}
