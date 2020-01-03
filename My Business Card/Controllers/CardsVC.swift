//
//  CardsVC.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit
import CoreData

class CardsVC: UIViewController {

    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

}

// MARK: - CollectionView delegates and datasource methods
extension CardsVC: UICollectionViewDelegate, UICollectionViewDataSource, AddQRCodeDelegate {
    func addQrCode(card: Card) {
        
    }
    
    // Set the amount of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath)
        
        // Set cell properties
        //cell.card = cards[indexPath.item]
        
        // Return cell
        return cell
        
    }
    
    
    
}
