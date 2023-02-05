// 
//  BNSegmentViewInstaller.swift
//  AppUI
//
//  Created by Botirjon Nasridinov on 06/06/22.
//

import Foundation
import UIKit
//

protocol BNSegmentViewInstaller: ViewInstaller {
    var stackView: UIStackView { get }
    var titleLabel: ContentHuggingLabel! { get set }
}


extension BNSegmentViewInstaller {
    
    func initSubviews() {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        
        titleLabel = ContentHuggingLabel()
        titleLabel.textAlignment = .center
    }
    
    
    func addSubviews() {
        mainView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }
    
    
    func addSubviewConstraints() {
    }
    
    func localizeTexts() {
        
    }
}

