//
//  TopCellContainer.swift
//  QRDS
//
//  Created by Irving Martinez on 1/4/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class TopCellContainer: UIView {
    
    var titleLabel = PrimaryLabel(text: Constants.defaultCardTitle)
    
    // MARK: Computed Properties
    
    private let titleIcon: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            imageView.image = UIImage(systemName: "person.crop.circle.fill")
            imageView.tintColor = UIColor.label
        }
        return imageView
    }()
    
    private let titleStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fillProportionally
        stacker.spacing = 4
        stacker.alignment = .center
        stacker.axis = .horizontal
        stacker.translatesAutoresizingMaskIntoConstraints = false
        return stacker
    }()
    
    var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: Inits
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        setup()
        setupTitle()
        setupQrImage()
    }
    
    // MARK: Setup UI
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func setupTitle() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            titleStackView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        titleStackView.addArrangedSubview(titleIcon)
        titleStackView.addArrangedSubview(titleLabel)
    }
    
    private func setupQrImage() {
        addSubview(qrImageView)
        qrImageView.dropShadow(color: .black)
        
        NSLayoutConstraint.activate([
            qrImageView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 6),
            qrImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            qrImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            qrImageView.widthAnchor.constraint(equalTo: qrImageView.heightAnchor)
            
        ])
    }
}
