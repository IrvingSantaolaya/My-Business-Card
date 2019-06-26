//
//  CardCollectionViewCell.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/5/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func showError(error: Bool)
}

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: CellDelegate?
    // Outlets
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var coloredView: UIView!
    
    // MARK: - Computed properties
    var card: Card? {
        didSet {
            setCard(card: card)
        }
    }
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCellUI()
    }
    
    // Helper Methods
    func configureCellUI() {
        // Content view border and rounded corners
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        // Colored view rounded corners
        coloredView.layer.cornerRadius = 10.0
        coloredView.layer.masksToBounds = true
    }
    // Set card to display
    func setCard(card: Card?) {
        // Check that card is not nil
        guard let card = card else {
            // Show error
            delegate?.showError(error: true)
            return
        }
        // Check that the qrcode exists for the card
        guard let imageData = card.qrCodeImage else {
            // Show error
            delegate?.showError(error: true)
            return
        }
        // Set the QRCode image for the cell
        let image = UIImage(data: imageData)
        qrImageView.image = image
    }
    
}
