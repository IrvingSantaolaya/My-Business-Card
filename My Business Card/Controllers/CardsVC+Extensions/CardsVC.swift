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
    
    var cards = [Card]()
    var collectionView: UICollectionView?
    var currentIndex = 0
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    var pageControl = UIPageControl()
    private let qrBuilder = QRCodeBuilder()
    
    // MARK: Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
        fetchSavedData()
        setupPageControl()
    }
    
    // MARK: Setup UI
    
    func setupNavBar() {
        title = Constants.cards
        if #available(iOS 13.0, *) {
            let image = UIImage(systemName: "plus")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addTapped))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.systemIndigo
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        }
    }
    
    func setupCollectionView() {
        collectionView?.delegate = self
        impactFeedbackgenerator.prepare()
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = width * 0.1
        layout.itemSize = CGSize(width: width * 0.9, height: height * 0.71)
        layout.scrollDirection = .horizontal
        let frame = CGRect(x: 0, y: (height - height * 0.8), width: width, height: height * 0.8)
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: width * 0.05, bottom: 10, right: width * 0.05)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "card")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = UIColor(named: Constants.backgroundColor)
        } else {
            collectionView.backgroundColor = .white
        }
        
        view.addSubview(collectionView)
        
    }
    
    func setupPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = cards.count
        pageControl.currentPage = 0
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        if #available(iOS 13.0, *) {
            pageControl.currentPageIndicatorTintColor = UIColor.systemIndigo
        } else {
            pageControl.currentPageIndicatorTintColor = .purple
        }
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 12),
            pageControl.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: Actions
    
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
    
    func deleteCard(indexPath: IndexPath) {
        // Delete card
        PersistenceService.context.delete(cards[indexPath.item])
        cards.remove(at: indexPath.item)
        
        collectionView?.deleteItems(at: [indexPath])
        collectionView?.reloadData()
        pageControl.numberOfPages = cards.count
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
            presentAlert()
        }
    }
}

// MARK: - CollectionView delegate methods

extension CardsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Flowlayout item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 0.9, height: height * 0.6)
    }
    
    // Amount of cards
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    // Custom cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCell
        
        // Set values
        cell.card = cards[indexPath.item]
        cell.index = indexPath
        cell.deleteDelegate = self
        cell.shareDelegate = self
        
        // Configure contentView
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            cell.contentView.layer.borderColor = UIColor.quaternarySystemFill.cgColor
        } else {
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        // Configure layer
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        cell.layer.shadowRadius = 8.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
}
// MARK: Custom delegate methods

extension CardsVC: Deletable, Shareable, CardReceivable {
    func shareTapped(index: IndexPath) {
        guard let qrCodeImage = cards[index.item].qrCodeImage else {
            presentAlert()
            return
        }
        // image to share
        let image = UIImage(data: qrCodeImage)
        // Check that image is not nil
        guard let checkedImage = image else {
            presentAlert()
            return
        }
        // Create and present activity sheet
        let imageToShare = [checkedImage]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func deleteTapped(index: IndexPath) {
        askToDelete(indexPath: index)
    }
    
    // Create and present action sheet
    func askToDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Are you sure you want to delete the current card?", message: "This cannot be undone.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            self.deleteCard(indexPath: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Add the new card to collection view, cards array, and save context
    func gotCard(card: Card) {
        cards.append(card)
        PersistenceService.saveContext()
        collectionView?.reloadData()
        pageControl.numberOfPages = cards.count
    }
}
