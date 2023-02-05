//
//  ContentHuggingLabel.swift
//  BNSegmentedControl
//
//  Created by Botirjon Nasridinov on 05/02/23.
//

import UIKit

public class ContentHuggingLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _initView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        _initView()
    }
    
    private func _initView() {
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
    }
}
