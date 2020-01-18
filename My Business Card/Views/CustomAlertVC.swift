//
//  CustomAlertVC.swift
//  QRDS
//
//  Created by Irving Martinez on 1/18/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class CustomAlertVC: UIViewController {

    // MARK: Properties
    let bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
    let padding: CGFloat = 16
    
    // MARK: Computed properties
    let alertContainer: UIView = {
        let container = UIView()
        if #available(iOS 13.0, *) {
            container.backgroundColor = .systemBackground
        } else {
            container.backgroundColor = .white
        }
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.white.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let titleLabel: PrimaryLabel = {
        let label = PrimaryLabel(text: Constants.alertTitle)
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let bodyLabel: SecondaryLabel = {
        let label = SecondaryLabel(text: Constants.alertBody)
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    
    let okButton: PrimaryButton = {
        var color = UIColor.purple
        if #available(iOS 13.0, *) { color = UIColor.systemIndigo }
        let button = PrimaryButton(color: color, title: "Ok")
        return button
    }()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: UI Methods
    private func setupUI() {
        view.backgroundColor = bgColor
        setupContainer()
        setupButton()
        setupLabels()
    }
    
    private func setupContainer() {
        view.addSubview(alertContainer)
        
        NSLayoutConstraint.activate([
            alertContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertContainer.widthAnchor.constraint(equalToConstant: 280),
            alertContainer.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    private func setupButton() {
        alertContainer.addSubview(okButton)
        okButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: alertContainer.bottomAnchor, constant: -padding),
            okButton.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: padding),
            okButton.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -padding),
            okButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupLabels() {
        alertContainer.addSubview(titleLabel)
        alertContainer.addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertContainer.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: alertContainer.leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: alertContainer.trailingAnchor, constant: -padding),
            bodyLabel.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -padding)
        ])
    }
    
    // MARK: Actions
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

}
