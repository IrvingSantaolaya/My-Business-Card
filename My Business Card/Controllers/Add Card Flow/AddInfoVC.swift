//
//  AddInfoVC.swift
//  QRDS
//
//  Created by Irving Martinez on 1/1/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class AddInfoVC: UIViewController {

    // MARK: Properties
    var card: Card?
    private let logoImageView = UIImageView()
    private let primaryLabel = PrimaryLabel(text: Constants.createCard)
    private let secondaryLabel = SecondaryLabel(text: Constants.enterInfo)
    private let circleView = CircleContainerView(size: 120)
    private let firstNameField = PrimaryTextField(placeholder: Constants.firstNameField)
    private let lastNameField = PrimaryTextField(placeholder: Constants.lastNameField)
    private let companyNameField = PrimaryTextField(placeholder: Constants.companyField)
    private let jobTitleField = PrimaryTextField(placeholder: Constants.jobTitleField)
    private let phoneField = PrimaryTextField(placeholder: Constants.phoneNumberField)
    private let padding: CGFloat = 20
    private let fieldHeight: CGFloat = 32
    
    var delegate: CardReceivable?
    
    // Computed properties
    private let nextButton: PrimaryButton = {
        var color: UIColor = UIColor.purple
        if #available(iOS 13.0, *) {
            color = UIColor.systemIndigo
        }
        return PrimaryButton(color: color, title: Constants.next)
    }()
    
    private let stackView: UIStackView = {
        let stacker = UIStackView()
        stacker.spacing = 10
        stacker.distribution = .equalSpacing
        stacker.translatesAutoresizingMaskIntoConstraints = false
        stacker.alignment = .fill
        stacker.axis = .vertical
        return stacker
    }()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageView()
        setupLabel()
        setupFields()
        addDismissKeyboardTapGesture()
        }
        
        deinit {
            removeAllGestureRecognizers()
        }
    
    //MARK: Actions
    @objc func nextTapped() {
        card?.firstName = firstNameField.text
        card?.lastName = lastNameField.text
        card?.phoneNumber = phoneField.text
        card?.company = companyNameField.text
        card?.jobTitle = jobTitleField.text
        
        let socialVC = SocialVC()
        socialVC.card = card
        socialVC.delegate = self
        
        navigationController?.pushViewController(socialVC, animated: true)
    }
    
    // MARK: UI Methods
    private func setupView() {
        title = Constants.enterContactInfo
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
        logoImageView.image = UIImage(named: Constants.card)
        logoImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(secondaryLabel)
        NSLayoutConstraint.activate([
            secondaryLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 10),
            secondaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondaryLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupFields() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        stackView.addArrangedSubview(firstNameField)
        stackView.addArrangedSubview(lastNameField)
        stackView.addArrangedSubview(phoneField)
        stackView.addArrangedSubview(companyNameField)
        stackView.addArrangedSubview(jobTitleField)
        
        NSLayoutConstraint.activate([
            firstNameField.heightAnchor.constraint(equalToConstant: fieldHeight),
            lastNameField.heightAnchor.constraint(equalToConstant: fieldHeight),
            companyNameField.heightAnchor.constraint(equalToConstant: fieldHeight),
            jobTitleField.heightAnchor.constraint(equalToConstant: fieldHeight),
            phoneField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        view.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            nextButton.heightAnchor.constraint(equalToConstant: 35),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
}

extension AddInfoVC: CardReceivable {
    
    func gotCard(card: Card) {
        delegate?.gotCard(card: card)
    }
}
