//
//  FirstNewCardVC.swift
//  QRDS
//
//  Created by Irving Martinez on 12/31/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class CreateCardVC: UIViewController {

    // MARK: Properties
    private let logoImageView = UIImageView()
    private let primaryLabel = PrimaryLabel(text: Constants.createCard)
    private let secondaryLabel = SecondaryLabel(text: Constants.createCardInfo)
    private let circleView = CircleContainerView(size: 120)
    private let textfield = PrimaryTextField(placeholder: Constants.cardNameField)
    private let padding: CGFloat = 20
    // Computed properties
    private let nextButton: PrimaryButton = {
        var color: UIColor = UIColor.purple
        if #available(iOS 13.0, *) {
            color = UIColor.systemIndigo
        }
        return PrimaryButton(color: color, title: Constants.next)
    }()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageView()
        setupLabels()
        setupField()
        setupButton()
        addDismissKeyboardTapGesture()
    }
    
    deinit {
        removeAllGestureRecognizers()
    }
    
    //MARK: Actions
    @objc func nextTapped() {
        let infoVC = AddInfoVC()
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    // MARK: UI Methods
    private func setupView() {
        title = Constants.createCard
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setupImageView() {
        
        view.addSubview(circleView)
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 120),
            circleView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        circleView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: Constants.cardInfo)
        logoImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupLabels() {
        view.addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            secondaryLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupField() {
        view.addSubview(textfield)
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 35),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textfield.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupButton() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: padding),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nextButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
