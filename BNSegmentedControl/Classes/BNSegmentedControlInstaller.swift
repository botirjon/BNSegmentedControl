// 
//  BNSegmentedControlInstaller.swift
//  AppUI
//
//  Created by Botirjon Nasridinov on 02/03/22.
//

import Foundation
import UIKit

protocol BNSegmentedControlInstaller: ViewInstaller {
    var collectionLayout: UICollectionViewFlowLayout! { get set }
    var collection: UICollectionView! { get set }
    var segmentIndicator: UIView! { get set }
    var scrollView: UIScrollView! { get set }
    var segmentIndicatorTrack: UIView! { get set }
    var shouldDisplaySegmentIndicatorTrack: Bool { get }
    var interSegmentSpacing: CGFloat { get }
    
    var intrinsicHeight: CGFloat { get }
    var segmentIndicatorHeight: CGFloat { get }
    
    var collectionHeightConstraint: NSLayoutConstraint! { get set }
    var segmentIndicatorTrackHeightConstraint: NSLayoutConstraint! { get set }
}


extension BNSegmentedControlInstaller {
    
    func initSubviews() {
        collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = interSegmentSpacing
        collectionLayout.minimumInteritemSpacing = interSegmentSpacing
    
        collection = UICollectionView.init(frame: .zero, collectionViewLayout: collectionLayout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.clipsToBounds = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.contentInset = .zero
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        segmentIndicator = UIView()
        segmentIndicator.backgroundColor = mainView.tintColor
        segmentIndicator.layer.cornerRadius = segmentIndicatorHeight/2
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentOffset.x = collection.contentOffset.x
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentIndicatorTrack = UIView()
        segmentIndicatorTrack.backgroundColor = mainView.tintColor.withAlphaComponent(0.3)
        segmentIndicatorTrack.isHidden = !shouldDisplaySegmentIndicatorTrack
        segmentIndicatorTrack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func addSubviews() {
        mainView.addSubview(collection)
        mainView.addSubview(segmentIndicatorTrack)
        mainView.addSubview(scrollView)
        scrollView.addSubview(segmentIndicator)
    }
    
    
    func addSubviewConstraints() {
        
        collectionHeightConstraint = collection.heightAnchor.constraint(equalToConstant: intrinsicHeight)
        
        segmentIndicatorTrackHeightConstraint = segmentIndicatorTrack.heightAnchor.constraint(equalToConstant: segmentIndicatorHeight)
        
        NSLayoutConstraint.activate([
            collection.leftAnchor.constraint(equalTo: collection.superview!.leftAnchor),
            collection.rightAnchor.constraint(equalTo: collection.superview!.rightAnchor),
            collection.centerYAnchor.constraint(equalTo: collection.superview!.centerYAnchor),
            collectionHeightConstraint,
            
            segmentIndicatorTrack.leftAnchor.constraint(equalTo: segmentIndicatorTrack.superview!.leftAnchor),
            segmentIndicatorTrack.rightAnchor.constraint(equalTo: segmentIndicatorTrack.superview!.rightAnchor),
            segmentIndicatorTrack.bottomAnchor.constraint(equalTo: segmentIndicatorTrack.superview!.bottomAnchor),
            segmentIndicatorTrackHeightConstraint,
            
            scrollView.leftAnchor.constraint(equalTo: scrollView.superview!.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: scrollView.superview!.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: scrollView.superview!.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        segmentIndicator.frame = CGRect(origin: .zero, size: .init(width: 0, height: 2))
    }
    
    func localizeTexts() {
        
    }
    
    func willLayout() {
        collectionHeightConstraint.constant = contentHeight()
    }
    
    func contentHeight() -> CGFloat {
        return max(mainView.bounds.size.height, BNSegmentedControl.LayoutMetrics.minCollectionViewHeight)
    }
}

