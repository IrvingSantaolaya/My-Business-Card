//
//  CardsViewController.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/5/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import CoreData

class CardsViewController: UIViewController {
    
    // MARK: - Properties
    
    // Cards array that will be used by core data and collection view
    var cards = [Card]()
    
    // Hold value for cell scaling
    let cellScaling: CGFloat = 0.7
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchSavedData()
    }
    
    // MARK: - Helper Methods
    func setupCollectionView() {
        
        view.setGradientBackground(colorOne: UIColor.FlatColor.Blue.LightBlue, colorTwo: UIColor.FlatColor.Blue.LighterBlue)
        // Get screen width and height and use it to calculate cell size
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        // Get insets and set layout
        let xInset = (view.bounds.width - cellWidth) / 2.0
        let yInset = (view.bounds.height - cellHeight) / 2.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        // Set up collectionview cell shadow effect
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 1)
        collectionView.layer.shadowOpacity = 0.5
        collectionView.layer.shadowRadius = 15.0
        collectionView.clipsToBounds = false
        collectionView.layer.masksToBounds = false
    }
    
    // Grab data that is saved by core data
    func fetchSavedData() {
        
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let cards = try PersistenceService.context.fetch(fetchRequest)
            self.cards = cards
            self.collectionView.reloadData()
        }
        catch {
            // Show alert
            Alert.unableToSave(vc: self)
        }
        
    }
    
    // Storyboard prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCardVC" {
            let destinationVC = segue.destination as! AddCardViewController
            destinationVC.delegate = self
        }
    }
    
}

// MARK: - AddQRCode delegate methods
extension CardsViewController: AddQRCodeDelegate {
    
    func addQrCode(card: Card) {
        // Add card to array and reload collectionview
        cards.append(card)
        PersistenceService.saveContext()
        collectionView.reloadData()
    }
}

// MARK: - CollectionView delegates and datasource methods
extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Set the amount of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Set cell properties
        cell.delegate = self
        cell.card = cards[indexPath.item]
        
        // Return cell
        return cell
        
    }
    
}

// MARK: - ScrollView Delegate methods
extension CardsViewController: UIScrollViewDelegate {
    
    // Create "Stop in the middle" effect for CollectionView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Get the layout for collectionView
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // Get width including spacing
        let cellWidthSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        // Get index by calculating amount of cells that have scrolled; rounded
        let index = (offset.x + scrollView.contentInset.left) / cellWidthSpacing
        let roundedIndex = round(index)
        // Set the offset
        offset = CGPoint(x: roundedIndex * cellWidthSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        // Stop at the offset
        targetContentOffset.pointee = offset
        
    }
}

// Delete cards delegate method
extension CardsViewController: DeleteCellDelegate {
    
    func deleteCell(cell: CardCollectionViewCell) {
        // Grab reference to the index path
        if let indexPath = collectionView.indexPath(for: cell) {
            // Make sure that the card is not nil
            if cell.card == nil {
                // Present alert
                Alert.unableToDelete(vc: self)
                collectionView.reloadData()
            }
            else {
                // Remove card in array, coredata store, and collectionview
                cards.remove(at: indexPath.item)
                PersistenceService.context.delete(cell.card!)
                collectionView.deleteItems(at: [indexPath])
                collectionView.reloadData()
            }
            
        }
        else {
            Alert.unableToDelete(vc: self)
            collectionView.reloadData()
        }
    }
}
