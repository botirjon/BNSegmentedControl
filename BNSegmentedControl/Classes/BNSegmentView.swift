// 
//  BNSegmentView.swift
//  AppUI
//
//  Created by Botirjon Nasridinov on 06/06/22.
//

import Foundation
import UIKit


internal class BNSegmentView: UIStackView, BNSegmentViewInstaller {
    
    internal struct Attributes {
        internal var normalTitleTextFont: UIFont = .systemFont(ofSize: 14)
        internal var selectedTitleTextFont: UIFont = .systemFont(ofSize: 14, weight: .bold)
        internal var normalTitleTextColor: UIColor = .black
        internal var selectedTitleTextColor: UIColor = .black
        internal var tintColor: UIColor = .systemBlue
        
        internal var normalTitleTextAttributes: [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: normalTitleTextColor,
                .font: normalTitleTextFont
            ]
        }
        
        internal var selectedTitleTextAttributes: [NSAttributedString.Key: Any] {
            return [
                .foregroundColor: selectedTitleTextColor,
                .font: selectedTitleTextFont
            ]
        }
    }
    
    var stackView: UIStackView { self }
    
    var titleLabel: ContentHuggingLabel!
    
    var badgeView: UIButton!
    
    var mainView: UIView { self }
    
    private let defaultAttributes: Attributes = .init()
    
    internal var attributes: Attributes? {
        didSet {
            setup()
        }
    }
    
    internal var appliedAttributes: Attributes {
        return attributes ?? defaultAttributes
    }
    
    internal var isSelected: Bool = false {
        didSet {
            setup()
        }
    }
    
    internal var title: String? {
        set {
            titleLabel.text = newValue
        }
        get {
            titleLabel.text
        }
    }
    
    internal var attributedTitle: NSAttributedString? {
        set {
            titleLabel.attributedText = newValue
        }
        get {
            titleLabel.attributedText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() {
        installSubviews()
        setupTargets()
        setup()
    }
    
    private var titleTextColor: UIColor {
        isSelected ? appliedAttributes.selectedTitleTextColor : appliedAttributes.normalTitleTextColor
    }
    
    private var titleTextFont: UIFont {
        isSelected ? appliedAttributes.selectedTitleTextFont : appliedAttributes.normalTitleTextFont
    }
    
    private func setup() {
        titleLabel.textColor = titleTextColor
        titleLabel.font = titleTextFont
        tintColor = appliedAttributes.tintColor
    }
    
    func setupTargets() {
        
    }
}
