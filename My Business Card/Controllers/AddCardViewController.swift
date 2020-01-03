//
//  AddCardViewController.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/6/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import Contacts

protocol AddQRCodeDelegate {
    func addQrCode(card: Card)
}

class AddCardViewController: UIViewController {
    
    // MARK: - Properties
    let qrBuilder = QRCodeBuilder()
    // Keyboard size constant to move view
    let keyboardSize: CGFloat = 258
    
    // Value to check if view is moved up
    var viewMoved = false
    
    // Outlets
    var delegate: AddQRCodeDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var topViewConstraint: NSLayoutConstraint!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup tapRecognizer method
        setupTapGesture()
        setupButtons()

    }
    
    // Remove Gesture Recognizers
    deinit {
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    // MARK: - IBActions
    
    // Cancel tapped
    @IBAction func cancelTapped(_ sender: Any) {
        
        // Make sure that keyboard is dismissed first
        UIView.animate(withDuration: 0.4, animations: {
            
            self.view.endEditing(true)
            self.topViewConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.viewMoved = false
        })
        
        // Dismiss view
        self.dismiss(animated: true, completion: nil)
    }
    
    // Save tapped
    @IBAction func saveTapped(_ sender: Any) {
        
        // Check that textfields are not empty
        if titleTextField.text == "" && firstNameTextfield.text == "" {
            Alert.incompleteInput(vc: self)
        }
        else if phoneNumberTextfield.text == "" && emailTextfield.text == "" {
            Alert.incompleteInput(vc: self)
        }
        else {
            // Create card
            let card = createCard()
            // Create a contact from the card
            let contact = qrBuilder.createContact(card: card)
            // Check for nil
            guard let qrCode = qrBuilder.createQr(contact: contact) else {
                Alert.invalidInput(vc: self)
                return
            }
            // Set QRCode image
            card.qrCodeImage = qrCode.pngData()
            // Pass image back CardsVC
            delegate?.addQrCode(card: card)
            view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Helper Methods
    
    // Set Tap Gesture Recognizer for keyboard dismissal
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    // Dismiss Keyboard
    @objc func viewTapped() {
        
        // Slide down view along with keyboard
        UIView.animate(withDuration: 0.4, animations: {
            
            self.view.endEditing(true)
            self.topViewConstraint.constant = 0
            self.view.layoutIfNeeded()
            self.viewMoved = false
        })

    }
    
    // Setup Buttons
    func setupButtons() {
        
        // Cancel Button round and shadow
        cancelButton.layer.cornerRadius = 0.5 * cancelButton.bounds.size.width
        cancelButton.clipsToBounds = true
        cancelButton.layer.shadowColor = UIColor.black.cgColor
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cancelButton.layer.shadowRadius = 5
        cancelButton.layer.shadowOpacity = 0.3
        cancelButton.layer.masksToBounds = false
        
        // Done Button round and shadow
        doneButton.layer.cornerRadius = 0.5 * doneButton.bounds.size.width
        doneButton.clipsToBounds = true
        doneButton.layer.shadowColor = UIColor.black.cgColor
        doneButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        doneButton.layer.shadowRadius = 5
        doneButton.layer.shadowOpacity = 0.3
        doneButton.layer.masksToBounds = false
    }
    
    // Create a card object
    func createCard() -> Card {
        
        let card = Card(context: PersistenceService.context)
        card.firstName = firstNameTextfield.text
        card.lastName = lastNameTextfield.text
        card.jobTitle = titleTextField.text
        card.email = emailTextfield.text
        card.phoneNumber = format(phoneNumber: phoneNumberTextfield.text ?? "")
        
        return card
    }
}


