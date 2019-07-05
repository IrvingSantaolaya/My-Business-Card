//
//  ACVC+TextfieldDelegates.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

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
            return count <= 35
        }
        if textField == firstNameTextfield || textField == lastNameTextfield {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 15
        }
        if textField == phoneNumberTextfield {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 20
        }
        if textField == emailTextfield {
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 45
        }
        
        return true
    }
    
    // Move View up when textfield is editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let height = (view.frame.height - textField.frame.origin.y) - 80
        
        
        if height <= keyboardSize && viewMoved == false {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.topViewConstraint.constant = self.keyboardSize
            self.view.layoutIfNeeded()
            self.viewMoved = true
            
        })
            
    }
    }
    
    // Move View down when keyboard is done editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    
    // User tapped on "Next" or "Done" on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        // Look for next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder?
        
        if nextResponder != nil {
            
            // Found next responder, so set it
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, or "Done" Pressed -> dismiss keyboard
            textField.resignFirstResponder()
        }
        
        return false
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

