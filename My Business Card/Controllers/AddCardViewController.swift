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
            let contact = createContact(card: card)
            // Check for nil
            guard let qrCode = createQr(contact: contact) else {
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
    
    // Build contact using "" as default values
    func createContact(card: Card) -> CNMutableContact {
        
        let contact = CNMutableContact()
        
        // Set contact first and last name
        contact.givenName = card.firstName ?? ""
        contact.familyName = card.lastName ?? ""
        contact.jobTitle = card.jobTitle ?? ""
        
        // Set contact email
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: card.email as NSString? ?? "")]
        
        // Set contact phone number with phone format
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue: card.phoneNumber ?? ""))]
        print(contact.phoneNumbers)
        return contact
    }
    
    // MARK: - Create a QR Code image
    func createQr(contact: CNMutableContact) -> UIImage? {
        
        // Convert contact into data
        let contactData = try? CNContactVCardSerialization.data(with: [contact])
        guard contactData != nil else {
            return nil
        }
        // Convert contact data into a string
        let dataString = String(data: contactData!, encoding: String.Encoding.ascii)
        
        // Get NSdata from the string
        let data = dataString?.data(using: String.Encoding.ascii)
        
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        
        return processedImage
    }
}

