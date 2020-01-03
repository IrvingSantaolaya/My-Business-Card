//
//  SocialVC.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

class SocialVC: UIViewController {
    
    // MARK: Properties
    private let logoImageView = UIImageView()
    private let secondaryLabel = SecondaryLabel(text: Constants.socialInfo)
    private let circleView = CircleContainerView(size: 120)
    private let twitterField = PrimaryTextField(placeholder: Constants.twitterField)
    private let linkedinField = PrimaryTextField(placeholder: Constants.linkedinField)
    private let emailField = PrimaryTextField(placeholder: Constants.emailField)
    private let twitterImageView = UIImageView()
    private let linkedinImageView = UIImageView()
    private let emailImageView = UIImageView()
    private let padding: CGFloat = 20
    private let fieldHeight: CGFloat = 32
    
    // Computed properties
    private let nextButton: PrimaryButton = {
        var color: UIColor = .blue
        if #available(iOS 13.0, *) {
            color = UIColor.systemGreen
        }
        return PrimaryButton(color: color, title: Constants.finish)
    }()
    
    private let stackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .equalCentering
        stacker.translatesAutoresizingMaskIntoConstraints = false
        stacker.alignment = .fill
        stacker.axis = .vertical
        return stacker
    }()
    
    private let twitterStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fill
        stacker.spacing = 8
        stacker.alignment = .leading
        stacker.axis = .horizontal
        stacker.translatesAutoresizingMaskIntoConstraints = false
        return stacker
    }()
    
    private let linkedinStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fill
        stacker.spacing = 8
        stacker.alignment = .leading
        stacker.axis = .horizontal
        stacker.translatesAutoresizingMaskIntoConstraints = false
        return stacker
    }()
    
    private let emailStackView: UIStackView = {
        let stacker = UIStackView()
        stacker.distribution = .fill
        stacker.spacing = 8
        stacker.alignment = .leading
        stacker.axis = .horizontal
        stacker.translatesAutoresizingMaskIntoConstraints = false
        return stacker
    }()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageView()
        setupLabel()
        setupFields()
        setupButton()
        addDismissKeyboardTapGesture()
    }
    
    deinit {
        removeAllGestureRecognizers()
    }
    
    //MARK: Actions
    @objc func nextTapped() {
        
    }
    
    // MARK: UI Methods
    private func setupView() {
        title = Constants.enterSocialInfo
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
        logoImageView.image = UIImage(named: Constants.social)
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
            stackView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        stackView.addArrangedSubview(emailStackView)
        emailImageView.image = UIImage(named: Constants.email)
        emailStackView.addArrangedSubview(emailImageView)
        emailStackView.addArrangedSubview(emailField)
        
        NSLayoutConstraint.activate([
            emailImageView.heightAnchor.constraint(equalToConstant: 28),
            emailImageView.widthAnchor.constraint(equalToConstant: 28),
            emailField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        stackView.addArrangedSubview(twitterStackView)
        twitterImageView.image = UIImage(named: Constants.twitter)
        twitterStackView.addArrangedSubview(twitterImageView)
        twitterStackView.addArrangedSubview(twitterField)
        
        NSLayoutConstraint.activate([
            twitterImageView.heightAnchor.constraint(equalToConstant: 28),
            twitterImageView.widthAnchor.constraint(equalToConstant: 28),
            twitterField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        
        stackView.addArrangedSubview(linkedinStackView)
        linkedinImageView.image = UIImage(named: Constants.linkedin)
        linkedinStackView.addArrangedSubview(linkedinImageView)
        linkedinStackView.addArrangedSubview(linkedinField)
        
        NSLayoutConstraint.activate([
            linkedinImageView.heightAnchor.constraint(equalToConstant: 28),
            linkedinImageView.widthAnchor.constraint(equalToConstant: 28),
            linkedinField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
    }
    
    private func setupButton() {
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
