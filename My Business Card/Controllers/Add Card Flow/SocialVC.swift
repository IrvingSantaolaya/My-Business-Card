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
    
    var card: Card?
    var activeTextField : UITextField?
    var delegate: CardReceivable?
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
    private let qrBuilder = QRCodeBuilder()
    
    // MARK: Computed properties
    
    private let nextButton: PrimaryButton = {
        var color: UIColor = UIColor.purple
        if #available(iOS 13.0, *) {
            color = UIColor.systemIndigo
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
        setupObservers()
        addDismissKeyboardTapGesture()
    }
    
    deinit {
        removeObserversAndRecognizers()
    }
    
    //MARK: Actions
    
    @objc func finishTapped() {
        if card != nil {
            card!.twitter = twitterField.text
            card!.linkedin = linkedinField.text
            card!.email = emailField.text
            let contact = qrBuilder.createContact(card: card!)
            guard let qrCode = qrBuilder.createQr(contact: contact) else { return }
            card!.qrCodeImage = qrCode.pngData()
            
            delegate?.gotCard(card: self.card!)
        }
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
        let fields = [twitterField, linkedinField, emailField]
        
        for field in fields {
            if field == twitterField {
                field.keyboardType = .twitter
            }
            else {
                field.keyboardType = .emailAddress
            }
            field.delegate = self
        }
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
        nextButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
    }
}

extension SocialVC: UITextFieldDelegate {
    
    // Limit text to 35 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return false }
        guard let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 45
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    // MARK: Textfield support
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        var shouldMoveViewUp = false
        var amount: CGFloat = 0
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = view.frame.height - keyboardSize.height
            // If the bottom of Textfield is below the top of keyboard, move up
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
                amount = bottomOfTextField - (topOfKeyboard - 12)
            }
        }
        if(shouldMoveViewUp) {
            view.frame.origin.y = 0 - amount
            if activeTextField == linkedinField && view.bounds.height < 630 {
                title = ""
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        title = Constants.enterSocialInfo
    }
}
