//
//  ViewController+Extensions.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/17/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

// Hide Keyboard - Used inside AddCardViewController
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
