// 
//  BNSegmentedControl.swift
//  AppUI
//
//  Created by Botirjon Nasridinov on 02/03/22.
//

import Foundation
import UIKit

open class BNSegmentedControl: UIControl, BNSegmentedControlInstaller {
    
    var collectionLayout: UICollectionViewFlowLayout!
    var collection: UICollectionView!
    var segmentIndicator: UIView!
    var scrollView: UIScrollView!
    var segmentIndicatorTrack: UIView!
    var mainView: UIView { self }
    
    let cellReuseIdentifier = "cell"
    let plainCellReuseIdentifier = "plain-cell"
    let badgedCellReuseIdentifier = "badged-cell"
    let animationDuration: TimeInterval = 0.2
    
    private var didLayoutOnce: Bool = false
    
    private let defaultAttributes: Attributes = .init()
    
    public var attributes: Attributes? {
        didSet {
            tintColor = appliedAttributes.tintColor
            collection.reloadData()
        }
    }
    
    private var appliedAttributes: Attributes {
        attributes ?? defaultAttributes
    }
    
    private var segmentAttributes: BNSegmentView.Attributes {
        .init(
            normalTitleTextFont: appliedAttributes.normalTitleTextFont,
            selectedTitleTextFont: appliedAttributes.selectedTitleTextFont,
            normalTitleTextColor: appliedAttributes.normalTitleTextColor,
            selectedTitleTextColor: appliedAttributes.selectedTitleTextColor,
            tintColor: tintColor
        )
    }
    
    public var segmentIndicatorHeight: CGFloat = LayoutMetrics.defaultSegmentIndicatorHeight {
        didSet {
            var frame = segmentIndicator.frame
            frame.size.height = segmentIndicatorHeight
            segmentIndicator.frame = frame
            segmentIndicatorTrackHeightConstraint.constant = segmentIndicatorHeight
        }
    }
    
    public var intrinsicHeight: CGFloat = LayoutMetrics.defaultHeight {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    var collectionHeightConstraint: NSLayoutConstraint!
    var segmentIndicatorTrackHeightConstraint: NSLayoutConstraint!
    
    open var shouldDisplaySegmentIndicatorTrack: Bool = true {
        didSet {
            segmentIndicatorTrack.isHidden = !shouldDisplaySegmentIndicatorTrack
        }
    }
    
    open var segmentTitles: [String] = [] {
        didSet {
            collection?.reloadData()
        }
    }
    
    open func insertSegment(withTitle title: String, at segment: Int) {
        if segment < 0 {
            segmentTitles.insert(title, at: 0)
        } else if segment >= segmentTitles.count {
            segmentTitles.append(title)
        } else {
            segmentTitles.insert(title, at: segment)
        }
        collection?.reloadData()
    }
    
    open func setTitle(_ title: String, forSegmentAt segment: Int) {
        if segment >= 0 && segment < segmentTitles.count {
            segmentTitles[segment] = title
            collection?.reloadData()
        }
    }
    
    open var interSegmentSpacing: CGFloat = 24 {
        didSet {
            collection?.collectionViewLayout.invalidateLayout()
        }
    }
    
    open var selectedSegmentIndex: Int = -1 {
        didSet {
            if oldValue != selectedSegmentIndex {
                collection.reloadData()
                moveSegmentIndicator()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    open var contentHorizontalInset: CGFloat = 0 {
        didSet {
            collection.collectionViewLayout.invalidateLayout()
        }
    }
    
    open var segmentWidth: SegmentWidth = .flex {
        didSet {
            collection.collectionViewLayout.invalidateLayout()
        }
    }
    
    open var segmentIndicatorWidth: SegmentIndicatorWidth = .wrapContent {
        didSet {
            moveSegmentIndicator()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initControl() {
        installSubviews()
        setupTargets()
        tintColor = defaultAttributes.tintColor
        collection.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        collection.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        willLayout()
        if !didLayoutOnce {
            moveSegmentIndicator()
            didLayoutOnce = true
        }
    }
    
    open override func tintColorDidChange() {
        collection.reloadData()
    }
    
    open override var intrinsicContentSize: CGSize {
        .init(width: super.intrinsicContentSize.width, height: intrinsicHeight)
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            var currentSize = scrollView.contentSize
            currentSize.width = collection.contentSize.width
            scrollView.contentSize = currentSize
        } else if keyPath == "contentOffset" {
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func setupTargets() {
        collection.delegate = self
        collection.dataSource = self
        collection.register(BNSegmentCollectionViewCell.self, forCellWithReuseIdentifier: badgedCellReuseIdentifier)
    }
    
    func moveSegmentIndicator() {
        guard selectedSegmentIndex >= 0, let attributes = collection.layoutAttributesForItem(at: IndexPath.init(row: selectedSegmentIndex, section: 0)) else { return }
        let indexPath = IndexPath.init(row: selectedSegmentIndex, section: 0)
        let frame = attributes.frame
        
        let indicatorOrigin: CGPoint
        let indicatorSize: CGSize
        
        switch segmentIndicatorWidth {
        case .wrapContent:
            let titleWidth = computeContentWidth(forSegment: selectedSegmentIndex)
            
            let xOffset = (frame.width-titleWidth)/2
            indicatorOrigin = .init(x: frame.origin.x+xOffset, y: frame.origin.y)
            indicatorSize = .init(width: titleWidth, height: segmentIndicatorHeight)
            
        case .wrapSegment:
            indicatorOrigin = .init(x: frame.origin.x, y: frame.origin.y)
            indicatorSize = .init(width: frame.size.width, height: segmentIndicatorHeight)
        }
        
        let indicatorFrame = CGRect(origin: indicatorOrigin, size: indicatorSize)
        
        let minX = frame.minX-collection.contentOffset.x
        let maxX = frame.maxX-collection.contentOffset.x
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: []) { [unowned self] in

            self.segmentIndicator.frame = indicatorFrame
            
            if minX < self.bounds.minX {
                self.collection.scrollToItem(at: indexPath, at: .left, animated: false)
            } else if maxX > self.bounds.maxX {
                self.collection.scrollToItem(at: indexPath, at: .right, animated: false)
            } else {
                self.scrollView.contentOffset.x = self.collection.contentOffset.x
            }
        } completion: { _ in
            // TODO: -
        }

    }
}


extension BNSegmentedControl: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentTitles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: badgedCellReuseIdentifier, for: indexPath) as! BNSegmentCollectionViewCell
        cell.title = segmentTitles[indexPath.row]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegmentIndex = indexPath.row
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = computeWidth(forSegment: indexPath.row)
        let sectionInsets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: indexPath.section)
        let contentInset = collectionView.contentInset
        
        let height = collectionView.bounds.size.height-sectionInsets.top-sectionInsets.bottom-contentInset.top-contentInset.top
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        interSegmentSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        interSegmentSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: contentHorizontalInset, bottom: 0, right: contentHorizontalInset)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset.x = scrollView.contentOffset.x
    }
    
    private func computeWidth(forSegment segment: Int) -> CGFloat {
        switch segmentWidth {
        case .flex:
            return computeContentWidth(forSegment: segment)
            
        case .fixed(let width):
            return width
        }
    }
    
    private func computeContentWidth(forSegment segment: Int) -> CGFloat {
        let v = BNSegmentView()
        v.title = segmentTitles[segment]
        v.layoutIfNeeded()
        return v.bounds.size.width
    }
}


public extension BNSegmentedControl {
    
    enum SegmentWidth {
        case fixed(CGFloat)
        case flex
    }
    
    enum SegmentIndicatorWidth {
        case wrapSegment
        case wrapContent
    }
}


internal extension BNSegmentedControl {
    struct LayoutMetrics {
        static let defaultHeight: CGFloat = 45
        static let minCollectionViewHeight: CGFloat = 18
        static let defaultSegmentIndicatorHeight: CGFloat = 2
    }
}

public extension BNSegmentedControl {
    
    struct Attributes {
        public var normalTitleTextFont: UIFont = .systemFont(ofSize: 14)
        public var selectedTitleTextFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
        public var normalTitleTextColor: UIColor = .black
        public var selectedTitleTextColor: UIColor = .black
        public var tintColor: UIColor = .systemBlue
        
        public var normalTitleTextAttributes: [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: normalTitleTextColor,
                .font: normalTitleTextFont
            ]
        }
        
        public var selectedTitleTextAttributes: [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: selectedTitleTextColor,
                .font: selectedTitleTextFont
            ]
        }
    }
}
