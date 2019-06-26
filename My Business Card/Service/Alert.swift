//
//  Alert.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/14/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

struct Alert {
    
    // Single option Alert
    private static func showAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    static func unableToDelete(vc: UIViewController) {
        showAlert(on: vc, with: "Unable to delete", message: "Please try again")
    }
    
    static func unableToSave(vc: UIViewController) {
        showAlert(on: vc, with: "Unable to save", message: "Please try again")
    }
    
    static func unableToLoad(vc: UIViewController) {
        showAlert(on: vc, with: "Unable to load", message: "Please try again")
    }
    
    static func invalidInput(vc: UIViewController) {
        showAlert(on: vc, with: "Invalid input", message: "Please try again")
    }
    
    static func incompleteInput(vc: UIViewController) {
        showAlert(on: vc, with: "Incomplete input", message: "Please add title or name, and a phone number or email.")
    }
    
}
