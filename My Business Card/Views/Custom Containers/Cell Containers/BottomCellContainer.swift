//
//  BottomCellContainer.swift
//  QRDS
//
//  Created by Irving Martinez on 1/4/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class BottomCellContainer: UIView {
    
    // MARK: Properties
    
    var workLabel = CardLabel()
    var nameLabel = CardLabel()
    var phoneLabel = CardLabel()
    private let circleView = CircleContainerView(size: 80)
    
    // MARK: Computed properties
    private let idImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.id)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let shareButton: PrimaryButton = {
        var color: UIColor = UIColor.purple
        if #available(iOS 13.0, *) {
            color = UIColor.systemIndigo
        }
        let button = PrimaryButton(color: color, title: Constants.share)
        return button
    }()
    
        let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.delete, for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let topContainer: SquareContainerView = {
        let container = SquareContainerView(radius: 10)
        container.backgroundColor = UIColor(named: Constants.containerColor)
        return container
    }()
    
    private let bottomContainer: SquareContainerView = {
        let container = SquareContainerView(radius: 10)
        container.backgroundColor = UIColor(named: Constants.containerColor)
        return container
    }()
    
    private let mainStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fillEqually
        stacker.translatesAutoresizingMaskIntoConstraints = false
        stacker.spacing = 12
        stacker.alignment = .fill
        stacker.axis = .vertical
        return stacker
    }()
    
    private let textStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fillEqually
        stacker.translatesAutoresizingMaskIntoConstraints = false
        stacker.spacing = 8
        stacker.alignment = .fill
        stacker.axis = .vertical
        return stacker
    }()
    
    private let buttonStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fillEqually
        stacker.translatesAutoresizingMaskIntoConstraints = false
        stacker.spacing = 16
        stacker.alignment = .fill
        stacker.axis = .vertical
        return stacker
    }()
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        setup()
        setupContainer()
        setupIdImage()
        setupText()
        setupButtons()
    }
    
    // MARK: Setup UI
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func setupContainer() {
        addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        mainStackView.addArrangedSubview(topContainer)
        mainStackView.addArrangedSubview(bottomContainer)
    }
    
    private func setupIdImage() {
        topContainer.addSubview(circleView)
        circleView.backgroundColor = UIColor(named: Constants.cardColor)
        
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            circleView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 4),
            circleView.widthAnchor.constraint(equalToConstant: 80),
            circleView.heightAnchor.constraint(equalToConstant: 80)
        ])
        circleView.addSubview(idImageView)
        
        NSLayoutConstraint.activate([
            idImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            idImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            idImageView.heightAnchor.constraint(equalToConstant: 55),
            idImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setupText() {
        topContainer.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            textStackView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            textStackView.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 6),
            textStackView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -2),
            textStackView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(workLabel)
        textStackView.addArrangedSubview(phoneLabel)
    }
    
    private func setupButtons() {
        bottomContainer.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: -20),
            shareButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 8),
            shareButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -8),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        bottomContainer.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 18),
            deleteButton
                .centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 60),
            deleteButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
