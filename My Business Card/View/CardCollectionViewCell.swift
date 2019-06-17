//
//  CardCollectionViewCell.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/5/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

protocol DeleteCellDelegate {
    func deleteCell(cell: CardCollectionViewCell)
}

class CardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var delegate: DeleteCellDelegate?
    // Outlets
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
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
    
    // IB Actions
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
            delegate?.deleteCell(cell: self)
    }
    
    
    // Helper Methods
    func setColors() {
            let color = UIColor.FlatColor.Blue.BlueWhale
            coloredView.backgroundColor = color
            titleLabel.textColor = color
            nameLabel.textColor = color
            phoneLabel.textColor = color
            emailLabel.textColor = color
            deleteButton.tintColor = color
            editButton.tintColor = color
    }
    func configureCellUI() {
        
        contentView.layer.cornerRadius = 15.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        setColors()
    }
    func setCard(card: Card?) {
        guard let card = card else {
            return
        }
        guard let image = UIImage(data: card.qrCodeImage as! Data) else {
            #warning("Handle error")
            return
        }
        qrImageView.image = image
        titleLabel.text = card.jobTitle
        nameLabel.text = "\(card.firstName!) \(card.lastName!)"
        phoneLabel.text = card.phoneNumber
        emailLabel.text = card.email
    }
    
}
