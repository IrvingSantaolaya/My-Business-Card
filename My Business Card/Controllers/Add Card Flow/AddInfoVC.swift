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
    var delegate: CardReceivable?
    var activeTextField : UITextField?
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
        setupObservers()
        setupView()
        setupImageView()
        setupLabel()
        setupFields()
        addDismissKeyboardTapGesture()
    }
    
    deinit {
        removeObserversAndRecognizers()
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
        
        let fields = [firstNameField, lastNameField, phoneField, companyNameField, jobTitleField]
        phoneField.keyboardType = .phonePad
        
        for field in fields {
            stackView.addArrangedSubview(field)
            field.delegate = self
        }
        
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

// MARK: Textfield Delegate methods and support

extension AddInfoVC: UITextFieldDelegate {
    
    // Limit text to 20 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return false }
        guard let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 20
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
            if activeTextField == companyNameField || activeTextField == jobTitleField {
                title = ""
            }
            else if activeTextField == phoneField && view.bounds.height < 630 {
                title = ""
            }
            view.frame.origin.y = 0 - amount
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        title = Constants.enterContactInfo
    }
}

// MARK: Receivable Delegate method
extension AddInfoVC: CardReceivable {
    
    func gotCard(card: Card) {
        delegate?.gotCard(card: card)
    }
}
