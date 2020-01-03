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
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
    }
    
    func configureCellUI() {
        // Content view border and rounded corners
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        // Colored view rounded corners
        backgroundColor = .black
    }
}
