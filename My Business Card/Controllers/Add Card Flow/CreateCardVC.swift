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
    var activeTextField : UITextField?
    var delegate: CardReceivable?
    var card = Card(context: PersistenceService.context)
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
        let button = PrimaryButton(color: color, title: Constants.next)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupImageView()
        setupLabels()
        setupField()
        setupButton()
        setupObservers()
        addDismissKeyboardTapGesture()
    }
    
    deinit {
        removeObserversAndRecognizers()
    }
    
    //MARK: Actions
    @objc func nextTapped() {
        let infoVC = AddInfoVC()
        card.cardName = textfield.text
        infoVC.card = card
        infoVC.delegate = self
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    // MARK: Configure UI
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
        textfield.delegate = self
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

// MARK: Delegate methods

extension CreateCardVC: UITextFieldDelegate {
    
    // Limit text to 35 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else { return false }
        guard let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count > 0 {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
        else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
        return count <= 25
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
            title = ""
            view.frame.origin.y = 0 - amount
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        title = Constants.createCard
    }
}

extension CreateCardVC: CardReceivable {
    func gotCard(card: Card) {
        delegate?.gotCard(card: card)
    }
}
