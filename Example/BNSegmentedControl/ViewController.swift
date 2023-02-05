//
//  ViewController.swift
//  BNSegmentedControl
//
//  Created by botirjon on 02/04/2023.
//  Copyright (c) 2023 botirjon. All rights reserved.
//

import UIKit
import BNSegmentedControl

class ViewController: UIViewController {

    private lazy var segmentedControl: BNSegmentedControl = {
        let segmentedControl = BNSegmentedControl()
        segmentedControl.segmentTitles = (0...Int.random(in: 5...10)).map({ index in
            "Segment \(index)"
        })
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControl.superview!.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControl.superview!.centerYAnchor),
            segmentedControl.widthAnchor.constraint(equalTo: segmentedControl.superview!.widthAnchor)
        ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

