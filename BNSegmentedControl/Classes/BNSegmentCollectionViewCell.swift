//
//  BNSegmentCollectionViewCell.swift
//  BNSegmentedControl
//
//  Created by Botirjon Nasridinov on 05/02/23.
//

import Foundation
import UIKit


internal class BNSegmentCollectionViewCell: UICollectionViewCell {
    
    internal typealias Attributes = BNSegmentView.Attributes
    
    private lazy var segmentView: BNSegmentView = {
        let segmentView = BNSegmentView()
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        return segmentView
    }()
    
    internal var attributes: Attributes? {
        set {
            segmentView.attributes = newValue
        }
        get {
            segmentView.attributes
        }
    }
    
    internal var title: String? {
        set {
            segmentView.title = newValue
        }
        get {
            segmentView.title
        }
    }
    
    internal var attributedTitle: NSAttributedString? {
        set {
            segmentView.attributedTitle = newValue
        }
        get {
            segmentView.attributedTitle
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initCell() {
        contentView.addSubview(segmentView)
        NSLayoutConstraint.activate([
            segmentView.centerXAnchor.constraint(equalTo: segmentView.superview!.centerXAnchor),
            segmentView.centerYAnchor.constraint(equalTo: segmentView.superview!.centerYAnchor)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            segmentView.isSelected = isSelected
        }
    }
}
