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
    var filteredCards = [Card]()
    var collectionView: UICollectionView?
    var currentIndex = 0
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavSearchBar()
        setupCollectionView()
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
        layout.itemSize = CGSize(width: width * 0.9, height: height * 0.7)
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: (height - height * 0.7), width: width, height: height * 0.7)
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
        self.present(navController, animated: true, completion: nil)
    }
    
}

// MARK: - CollectionView delegates and datasource methods
extension CardsVC: UICollectionViewDelegate, UICollectionViewDataSource, AddQRCodeDelegate {
    func addQrCode(card: Card) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        // in case you you want the cell to be 40% of your controllers view
        return CGSize(width: width * 0.9, height: height * 0.6)
    }
    
    // Set the amount of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCell
        
        // Set cell properties
        //cell.card = cards[indexPath.item]
        
        // Return cell
        return cell
        
    }
    
}
