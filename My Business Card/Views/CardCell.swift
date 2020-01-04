//
//  CardCell.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    private var titleLabel = PrimaryLabel(text: Constants.defaultCardTitle)
    private let squareView = SquareContainerView(radius: 20)
    
    var card: Card? {
        didSet {
            setCard(card: card)
        }
    }
    
    var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellUI()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellUI() {
        // Content view border and rounded corners
        
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = UIColor.systemGray6
            contentView.layer.borderColor = UIColor.systemGray.cgColor
        } else {
            contentView.backgroundColor = .lightGray
            contentView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    private func setupImage() {
        if #available(iOS 13.0, *) {
            squareView.backgroundColor = UIColor.systemIndigo
        } else {
            squareView.backgroundColor = UIColor.purple
        }
        contentView.addSubview(squareView)
        
        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            squareView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            squareView.widthAnchor.constraint(equalToConstant: 220),
            squareView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        squareView.addSubview(qrImageView)
        
        NSLayoutConstraint.activate([
            qrImageView.centerXAnchor.constraint(equalTo: squareView.centerXAnchor),
            qrImageView.centerYAnchor.constraint(equalTo: squareView.centerYAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 200),
            qrImageView.heightAnchor.constraint(equalToConstant: 200)
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
        qrImageView.image = image
        titleLabel.text = card.cardName
    }
}
