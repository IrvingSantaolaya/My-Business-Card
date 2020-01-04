//
//  CardsVC.swift
//  QRDS
//
//  Created by Irving Martinez on 1/2/20.
//  Copyright © 2020 Irving Martinez. All rights reserved.
//

import UIKit
import CoreData

class CardsVC: UIViewController, CardReceiverDelegate {
    
    // MARK: - Properties
    var cards = [Card]()
    var collectionView: UICollectionView?
    var currentIndex = 0
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    private let qrBuilder = QRCodeBuilder()
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavSearchBar()
        setupCollectionView()
        fetchSavedData()
    }

    // MARK: Setup UI
    func setupNavSearchBar() {
        title = Constants.cards
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func setupCollectionView() {
        
        impactFeedbackgenerator.prepare()
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: -55, right: 10)
        layout.itemSize = CGSize(width: width * 0.9, height: height * 0.8)
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: (height - height * 0.8), width: width, height: height * 0.8)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "card")
        
        
        
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = UIColor.systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        view.addSubview(collectionView)
    }
    
    @objc func addTapped() {
        let newCardVC = CreateCardVC()
        let navController = UINavigationController(rootViewController: newCardVC)
        newCardVC.delegate = self
        self.present(navController, animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        print("Here")
    }
    
    // MARK: Helpers
    func fetchSavedData() {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        
        do {
            let cards = try PersistenceService.context.fetch(fetchRequest)
            self.cards = cards
            self.collectionView?.reloadData()
        }
        catch {
            // Show alert
            #warning("alert")
        }
    }
    
    func deleteCard() {
        // Delete card
        // Remove card in array, coredata store, and collectionview
        PersistenceService.context.delete(cards[currentIndex])
        cards.remove(at: currentIndex)
        
        let index = IndexPath(item: currentIndex, section:  0)
        collectionView?.deleteItems(at: [index])
        collectionView?.reloadData()
    }
}

// MARK: - Delegates and datasource methods
extension CardsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 0.9, height: height * 0.6)
    }
    
    // Set the amount of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCell
        
        cell.card = cards[indexPath.item]
        
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.masksToBounds = true

        cell.layer.shadowColor = cell.backgroundColor?.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        return cell
        
    }
    
    func gotCard(card: Card) {
        
        cards.append(card)
        PersistenceService.saveContext()
        collectionView?.reloadData()
    }
    
}
