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
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        impactFeedbackgenerator.impactOccurred()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
