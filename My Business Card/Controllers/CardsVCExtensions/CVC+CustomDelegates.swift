//
//  CardsViewController+CustomDelegates.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import CoreData

// MARK: - AddQRCode delegate methods
extension CardsViewController: AddQRCodeDelegate {
    
    func addQrCode(card: Card) {
        // Add card to array and reload collectionview
        cards.append(card)
        PersistenceService.saveContext()
        collectionView.reloadData()
        setLabels()
        
        // Check to see if there are 20 cards
        if cards.count >= 20 {
            // Disable add button
            addButton.isEnabled = false
        }
    }
}

// Show error
extension CardsViewController: CellDelegate {
    func showError(error: Bool) {
        Alert.unableToLoad(vc: self)
        collectionView.reloadData()
    }
}

