//
//  CardCell.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

protocol Deletable {
    func deleteTapped(index: IndexPath)
}

class CardCell: UICollectionViewCell {
    
    private var topContainerView = TopCellContainer()
    private let bottomContainerView = BottomCellContainer()
    private var height: CGFloat?
    private var width: CGFloat?
    var delegate: Deletable?
    
    var index: IndexPath?
    var card: Card? {
        didSet {
            setCard(card: card)
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        height = contentView.frame.height
        width = contentView.frame.width
        configureCellUI()
        setupContainers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellUI() {
        // Content view border and rounded corners
        contentView.backgroundColor = UIColor(named: Constants.cardColor)
        bottomContainerView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func setupContainers() {
        
        guard let height = height, let width = width else { return }
        
        addSubview(topContainerView)
        addSubview(bottomContainerView)
        NSLayoutConstraint.activate([
            topContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topContainerView.topAnchor.constraint(equalTo: topAnchor),
            topContainerView.widthAnchor.constraint(equalToConstant: width),
            topContainerView.heightAnchor.constraint(equalToConstant: height / 2),
            
            bottomContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomContainerView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            bottomContainerView.widthAnchor.constraint(equalToConstant: width),
            bottomContainerView.heightAnchor.constraint(equalToConstant: height / 2)
        ])

    }
    
    func setCard(card: Card?) {
        // Check that card is not nil
        guard let card = card else {
            // Show error
            return
        }
        // Check that the qrcode exists for the card
        guard let imageData = card.qrCodeImage else {
            // Show error
            return
        }
        // Set the QRCode image for the cell
        let image = UIImage(data: imageData)
        topContainerView.qrImageView.image = image
        topContainerView.titleLabel.text = card.cardName
        
        // Using "!" because it will produce an empty string
        bottomContainerView.nameLabel.text = "\(card.firstName!) \(card.lastName!)"
        bottomContainerView.phoneLabel.text = "\(card.phoneNumber!)"
        
        if card.jobTitle != "" && card.company != ""{
            bottomContainerView.workLabel.text = "\(card.jobTitle!) @ \(card.company!)"
        }
        
        else {
            bottomContainerView.workLabel.text = card.jobTitle != nil ? card.jobTitle! : card.company!
        }
        
    }
    
    @objc func deleteTapped() {
        guard let index = index else { return }
        delegate?.deleteTapped(index: index)
    }
}
