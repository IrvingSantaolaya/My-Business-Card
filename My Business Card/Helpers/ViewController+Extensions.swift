//
//  ViewController+Extensions.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Add dismiss gesture for keyboard
    func addDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func removeObserversAndRecognizers() {
        for recognizer in self.view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
        NotificationCenter.default.removeObserver(self)
    }
}
