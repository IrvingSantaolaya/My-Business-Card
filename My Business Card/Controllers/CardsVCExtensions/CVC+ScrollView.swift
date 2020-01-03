//
//  CardsViewController+ScrollView.swift
//  My Business Card
//
//  Created by Irving Martinez on 6/26/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

// MARK: - ScrollView Delegate methods
extension CardsVC: UIScrollViewDelegate {
    
    // Create "Stop in the middle" effect for CollectionView
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.5)
        // Get the layout for collectionView
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        // Get width including spacing
        let cellWidthSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        // Get index by calculating amount of cells that have scrolled; rounded
        let index = (offset.x + scrollView.contentInset.left) / cellWidthSpacing
        let roundedIndex = round(index)
        // Set current Index global
        currentIndex = Int(roundedIndex)
        // Set the offset
        offset = CGPoint(x: roundedIndex * cellWidthSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        // Stop at the offset
        targetContentOffset.pointee = offset
        impactFeedbackgenerator.impactOccurred()
    }
    
}
