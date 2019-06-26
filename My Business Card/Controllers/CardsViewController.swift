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
    let cellScaling: CGFloat = 0.75
    
    // Hold value for current index
    var currentIndex = 0
    let maxNumberOfCards = 20
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var currentCardNumberLabel: UILabel!
    @IBOutlet weak var amountOfCardsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        fetchSavedData()
        setupBottomView()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setLabels()
    }
    
    // MARK: - Helper Method
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let screenSize = UIScreen.main.bounds.size
        let cellSize = floor(screenSize.width * cellScaling)
        
        // Calculate insets and set layout
        let inset = (view.bounds.width - cellSize) / 2.0
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionView.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        // Set up collectionview cell shadow effect
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 1)
        collectionView.layer.shadowOpacity = 0.5
        collectionView.layer.shadowRadius = 5.0
        collectionView.clipsToBounds = false
        collectionView.layer.masksToBounds = false
    }
    
    // Set up labels
    func setLabels() {
        // Check if index is out of bounds
        if currentIndex >= cards.count {
            currentIndex -= 1
        }
        // Update the current index label
        currentCardNumberLabel.text = String(currentIndex + 1)
        // Update the amount of cards label
        amountOfCardsLabel.text = "\(cards.count)/\(maxNumberOfCards)"
        
        // Reset card index and clear labels
        if cards.count == 0 {
            currentIndex = 0
            currentCardNumberLabel.isHidden = true
            setButtons(enabled: false)
            titleLabel.text = nil
            nameLabel.text = nil
            numberLabel.text = nil
            emailLabel.text = nil
            return
        } else
        {
            // Set current card and text labels
            setButtons(enabled: true)
            currentCardNumberLabel.isHidden = false
            let currentCard = cards[currentIndex]
            titleLabel.text = currentCard.jobTitle
            nameLabel.text = " \((currentCard.firstName ?? "")) \((currentCard.lastName ?? ""))"
            numberLabel.text = currentCard.phoneNumber
            emailLabel.text = currentCard.email
        }
        
    }
    
    // Set button active status
    func setButtons(enabled: Bool) {
        deleteButton.isEnabled = enabled
    }
    // Configure Bottom View
    func setupBottomView() {
        
        // Delete Button round and shadow
        deleteButton.layer.cornerRadius = 0.5 * deleteButton.bounds.size.width
        deleteButton.clipsToBounds = true
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        deleteButton.layer.shadowRadius = 5
        deleteButton.layer.shadowOpacity = 0.3
        deleteButton.layer.masksToBounds = false
        
        // Add Button round and shadow
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.masksToBounds = false
        
        // Current Card Label round
        currentCardNumberLabel.layer.cornerRadius = 0.5 * currentCardNumberLabel.bounds.size.width
        currentCardNumberLabel.clipsToBounds = true
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
            Alert.unableToLoad(vc: self)
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func deleteButtonPressed(_ sender: Any) {
        askToDelete()

    }
    
    func deleteCard() {
        // Delete card
        // Remove card in array, coredata store, and collectionview
        PersistenceService.context.delete(cards[currentIndex])
        cards.remove(at: currentIndex)
        
        
        let index = IndexPath(item: currentIndex, section:  0)
        collectionView.deleteItems(at: [index])
        collectionView.reloadData()
        setLabels()
        PersistenceService.saveContext()
        
        // Check that there are less than 20 cards
        if cards.count < 20 {
            
            // Enable add button
            addButton.isEnabled = true
        }
    }
    
    // Create action sheet to confirm deletion
    func askToDelete() {
        
        // Action Sheet title and message
        let alert = UIAlertController(title: "Are you sure you want to delete the current QRD?", message: "This cannot be undone.", preferredStyle: .actionSheet)
        
        // "Yes" option
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.deleteCard()
        }))
        // "Cancel" option
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present action sheet
        self.present(alert, animated: true)
    }
    
    
    // Storyboard prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddCardVC" {
            let destinationVC = segue.destination as! AddCardViewController
            destinationVC.delegate = self
        }
    }
    
}
