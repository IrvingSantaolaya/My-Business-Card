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
    var delegate: AddQRCodeDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObserver()
    }
    
    // MARK: - IBActions
    @IBAction func cancelTapped(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let card = createCard()
        let contact = createContact(card: card)
        guard let qrCode = createQr(contact: contact) else {
            Alert.invalidInput(vc: self)
            return
        }
        card.qrCodeImage = qrCode.pngData()
        delegate?.addQrCode(card: card)
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Methods
    
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
    
    // Build contact
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
            Alert.invalidInput(vc: self)
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
        
        // Invert the colors
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil}
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil}
        
        // Replace the black with transparency
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil}
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil}
        
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil}
        let processedImage = UIImage(cgImage: cgImage)
        
        return processedImage
    }
    
    func setupKeyboardObserver() {

        
    }
}
// MARK: - Textfield delegate and helper methods
extension AddCardViewController: UITextFieldDelegate {
    
    // Set character limits for textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        if textField == titleTextField {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 30
        }
        if textField == firstNameTextfield || textField == lastNameTextfield {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 20
        }
        if textField == phoneNumberTextfield {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 20
        }
        
        return true
    }
    
    // Turn phone number string into phone-number-format if possible
    func format(phoneNumber sourcePhoneNumber: String) -> String {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return sourcePhoneNumber
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return sourcePhoneNumber
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return sourcePhoneNumber
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return sourcePhoneNumber
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }

}
